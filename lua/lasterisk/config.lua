local config = {
  is_whole = true,
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
