local fn = vim.fn
local api = vim.api

-- local function pp(obj)
--   print(vim.inspect(obj))
-- end

---@class LasteriskConfig
---@field is_whole boolean
local default_config = {
  is_whole = true,
}

---@generic T : any
---@varargs T
---@return T | {}
local function handle_args(...)
  local args = { ... }
  if #args == 0 then
    return {}
  end

  return args[1]
end

---@param cword string
---@param config LasteriskConfig
---@return string
local function cword_pattern(cword, config)
  if config.is_whole and fn.match(cword, "\\k") >= 0 then
    return string.format("\\<%s\\>", fn.escape(cword, "\\"))
  else
    return cword
  end
end

---Set register and search pattern history
---@param pattern string
local function set_search(pattern)
  fn.setreg("/", pattern)
  fn.histadd("/", pattern)
end

---Sort pos1 and pos2
---@param pos1 number[] [line, col]
---@param pos2 number[] [line, col]
---@return number[] [line, col] start_pos
---@return number[] [line, col] end_pos
local function sort_pos(pos1, pos2)
  if pos1[1] == pos2[1] then
    if pos1[2] > pos2[2] then
      return pos2, pos1
    end
    return pos1, pos2
  else
    if pos1[1] > pos2[1] then
      return pos2, pos1
    end
    return pos1, pos2
  end
end

--- Get selected text
---@param mode string 'V' | 'v'
---@return string selected text
local function get_selected_text(mode)
  local v_pos = vim.list_slice(fn.getcharpos("v"), 2, 3)
  local dot_pos = vim.list_slice(fn.getcharpos("."), 2, 3)

  local start_pos, end_pos = sort_pos(v_pos, dot_pos)

  local lines = fn.getline(start_pos[1], end_pos[1])
  if mode == "v" then
    if #lines == 1 then
      lines[1] = fn.strcharpart(lines[1], start_pos[2] - 1, end_pos[2] - start_pos[2] + 1)
    else
      lines[1] = fn.strcharpart(lines[1], start_pos[2] - 1)
      lines[#lines] = fn.strcharpart(lines[#lines], 0, end_pos[2])
    end
  end
  return fn.join(vim.tbl_map(function(line) return fn.escape(line, [[\/]]) end, lines), [[\n]])
end

local M = {}

--- lasterisk.nvim main func
---@vararg LasteriskConfig
M.search = function(...)
  local config = vim.tbl_deep_extend("force", default_config, handle_args(...))

  local mode = fn.mode()
  if mode ~= "n" and mode ~= "V" and mode ~= "v" then
    api.nvim_echo({ { "lasterisk.nvim: support normal, visual by character, visual by line only!", "WarningMsg" } }, true, {})
    return
  end

  if config.is_whole == true and (mode == "v" or mode == "V") then
    api.nvim_echo({ { "lasterisk.nvim: Not support, visual asterisk and is_whole: true!", "WarningMsg" } }, true, {})
    return
  end

  local pattern
  local view
  if mode == "n" then
    local cword = fn.escape(fn.expand("<cword>"), [==[~\.^$[]*]==])
    if cword == "" then
      api.nvim_echo({ { "lasterisk.nvim: No selected string", "WarningMsg" } }, true, {})
      return
    end

    pattern = cword_pattern(cword, config)
  elseif mode == "v" or mode == "V" then
    pattern = [[\V]] .. get_selected_text(mode)
    view = fn.winsaveview()
  end

  vim.opt.hlsearch = vim.opt.hlsearch
  set_search(pattern)
  api.nvim_echo({ { pattern } }, false, {})

  if mode == "v" or mode == "V" then
    api.nvim_feedkeys(api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
    fn.winrestview(view)
  end
end

return M
