local fn = vim.fn

--- @param str string
--- @return string
local function escape_pattern(str)
  return fn.escape(str, [==[~"\.^$[]*]==])
end

--- @return nil
local function generate_error_msg()
  vim.api.nvim_echo({'lasterisk.nvim: No selected string', 'echohl'}, true, {})
end

---@param cword string
---@param config table
---@return string
local function cword_pattern(cword, config)
  if config.is_whole and fn.match(cword, '\\k') >= 0 then
    return string.format('\\<%s\\>', cword)
  else
    return cword
  end
end

--- @param pattern string
--- @return nil
local function set_search(pattern)
  fn.setreg('/', pattern)
  fn.histadd('/', pattern)
end

local M = {}

--- @param config table
--- @return string
M.lasterisk_do = function(config)
  local cword = escape_pattern(fn.expand('<cword>'))
  if cword == '' then
    return generate_error_msg()
  end

  local pattern = cword_pattern(cword, config)

  vim.o.hlsearch = vim.o.hlsearch

  set_search(pattern)
  print("/" .. fn.escape(pattern, '\\"'))
end

return M
