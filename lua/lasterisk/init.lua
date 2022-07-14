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
  local args = {...}
  if #args == 0 then
    return {}
  end

  return args[1]
end

---@return nil
local function generate_error_msg()
  api.nvim_echo({'lasterisk.nvim: No selected string', 'echohl'}, true, {})
end

---@param cword string
---@param config LasteriskConfig
---@return string
local function cword_pattern(cword, config)
  if config.is_whole and fn.match(cword, '\\k') >= 0 then
    return string.format('\\<%s\\>', fn.escape(cword, '\\'))
  else
    return cword
  end
end

---Set register and search pattern history
---@param pattern string
local function set_search(pattern)
  fn.setreg('/', pattern)
  fn.histadd('/', pattern)
end

---Sort pos1 and pos2
---@param pos1 string[] [line, col]
---@param pos2 string[] [line, col]
---@return string[] [line, col]
---@return string[] [line, col]
local function sort_pos(pos1, pos2)
  if pos1[1] == pos2[1] then
    if pos1[2] > pos2[2] then
      return pos2, pos1
    end
    return pos1, pos2
  else
    if pos1[1] > pos2[1]then
      return pos2, pos1
    end
    return pos1, pos2
  end
end

--- Get selected text
---@param mode string 'V' | 'v'
---@return string selected text
local function get_selected_text(mode)
  local bufnr = api.nvim_get_current_buf()
  local v_pos = vim.list_slice(fn.getpos("v"), 2, 3)
  local dot_pos = vim.list_slice(fn.getpos("."), 2, 3)

  local start_pos, end_pos = sort_pos(v_pos, dot_pos)
  local region = vim.region(bufnr, start_pos, end_pos, mode, true)

  local linenrs = vim.tbl_keys(region)
  table.sort(linenrs)

  local lines
  if mode == "V" then
    lines = api.nvim_buf_get_lines(bufnr, linenrs[1] - 1, linenrs[#linenrs], false)
  elseif mode == 'v' then
    -- TODO
    lines = {}
  else
    lines = {}
  end
  return fn.join(vim.tbl_map(function(line) return fn.escape(line, [[\/]]) end, lines), [[\n]])
end

local function visual_search(mode)
  local pattern = [[\V]] .. get_selected_text(mode)
  local view = fn.winsaveview()
  vim.o.hlsearch = vim.o.hlsearch

  set_search(pattern)
  print("/" .. pattern)
  api.nvim_feedkeys(api.nvim_replace_termcodes('<esc>',true,false,true),'n',true)
  fn.winrestview(view)
end

local function normal_search(config)
  local cword = fn.escape(fn.expand('<cword>'), [==[~\.^$[]*]==])
  if cword == '' then
    return generate_error_msg()
  end

  local pattern = cword_pattern(cword, config)

  vim.o.hlsearch = vim.o.hlsearch

  set_search(pattern)
  print("/" .. pattern)
end

local M = {}

---@vararg LasteriskConfig
M.search = function(...)
  local config = vim.tbl_deep_extend('force', default_config, handle_args(...))

  local mode = fn.mode()
  if mode == 'n' then
    normal_search(config)
  elseif mode == 'v' or mode == 'V' then
    visual_search(mode)
  end
end

return M
