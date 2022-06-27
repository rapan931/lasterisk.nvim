local config = {
  direction = true,
  do_jump = false,
  is_whole = true,
  keeppos = false
}

local M = {}

M.set = function(override)
  local merged_config = vim.tbl_deep_extend('force', config, override)
  return merged_config
end
M.get = function()
  return config
end

return M
