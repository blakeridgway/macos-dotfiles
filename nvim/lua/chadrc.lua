---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
}

-- Enable the startup dashboard
M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  tabufline = {
    lazyload = false,
  },
}

return M
