local M = {}

local config = require("quickgd.lib.config")
local command = require("quickgd.commands")
local str = require("quickgd.lib.str")

function M.setup(opts)
	config.set_user_config(opts)

	if config.treesitter then
		vim.treesitter.language.register("glsl", "gdshader")
		vim.treesitter.language.register("glsl", "gdshaderinc")
	end

	if config.cmp then
		require("quickgd.cmp")
	end

	-- Register commands
	local set_command = vim.api.nvim_create_user_command
	for key, value in pairs(command) do
		local name = str.name_from_function(key)
		M[key] = value
		set_command(tostring(name), M[key], {})
	end

	-- Set gdshaderinc filetype
	vim.filetype.add({
		filename = {
			[".gdshaderinc"] = "gdshader",
		},
	})
end

return M
