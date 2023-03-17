local M = {}

local config = require("quickgd.lib.config")
local command = require("quickgd.commands")
local str = require("quickgd.lib.str")

function M.treesitter()
  vim.treesitter.language.register("glsl", "gdshader")
  vim.api.nvim_create_augroup("quickgd", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "gdscript",
    callback = function()
      vim.api.nvim_command(":TSEnable glsl")
    end
  })
end

function M.setup(opts)
  config.set_user_config(opts)


  -- Register commands
  local set_command = vim.api.nvim_create_user_command
  for key, value in pairs(command) do
    local name = str.name_from_function(key)
    M[key] = value
    set_command(tostring(name), M[key], {})
  end
end

return M
