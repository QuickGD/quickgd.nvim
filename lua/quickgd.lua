local M = {}

local config = require("quickgd.config")
local command = require("quickgd.commands")
local util = require("quickgd.util")

function M.setup(opts)
  config.set_user_config(opts)

  local set_command = vim.api.nvim_create_user_command
  for key, value in pairs(command) do
    local name = util.name_from_function(key)
    M[key] = value
    set_command(tostring(name), M[key], {})
  end
end

return M
