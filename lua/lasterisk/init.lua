local fn = vim.fn
local api = vim.api

---@class config
---@field is_whole boolean
local default_config = {
  is_whole = true,
}

--- @param str string
--- @return string
local function escape_pattern(str)
  return fn.escape(str, [==[~"\.^$[]*]==])
end

--- @return nil
local function generate_error_msg()
  api.nvim_echo({'lasterisk.nvim: No selected string', 'echohl'}, true, {})
end

--- @param cword string
--- @param config config
--- @return string
local function cword_pattern(cword, config)
  if config.is_whole and fn.match(cword, '\\k') >= 0 then
    return string.format('\\<%s\\>', fn.escape(cword, '\\'))
  else
    return cword
  end
end

--- @param pattern string
local function set_search(pattern)
  fn.setreg('/', pattern)
  fn.histadd('/', pattern)
end

local M = {}

--- @param override_config config
M.search = function(override_config)
  local config = vim.tbl_deep_extend('force', default_config, override_config)
  local cword = escape_pattern(fn.expand('<cword>'))
  if cword == '' then
    return generate_error_msg()
  end

  local pattern = cword_pattern(cword, config)
  vim.o.hlsearch = vim.o.hlsearch

  set_search(pattern)
  print("/" .. pattern)
end

return M
