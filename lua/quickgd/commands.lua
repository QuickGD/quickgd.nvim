local M = {}

local fs = require("quickgd.lib.fs")
local config = require("quickgd.lib.config")
local telescope = require("quickgd.lib.telescope")
local actions = telescope.actions
local actions_state = telescope.actions_state

function M.godot_start()
	local command = string.format("silent! !%s %s", config.godot_path, config.project_path)
	vim.api.nvim_command(command)
end

function M.godot_run()
	local function run_scene(prompt_bufnr)
		actions.select_default:replace(function()
			actions.close(prompt_bufnr)
			local selected = actions_state.get_selected_entry()
			config.last_scene = selected.path
			local command = string.format("silent! !%s %s", config.godot_path, selected.path)
			vim.api.nvim_command(command)
		end)
		return true
	end

	if config.telescope then
		telescope.run_func_on_selected({
			name = "TSCN",
			attach_mappings = run_scene,
			results = fs.get_files_by_end,
			results_args = ".tscn",
		})
	else
		local list = fs.get_files_by_end(".tscn", "false")
		vim.ui.select(list.name or {}, {
			prompt = "TSCN",
		}, function(_, index)
			if index ~= nil then
				config.last_scene = list.path[index]
				local command = string.format("silent! !%s %s", config.godot_path, list.path[index])
				vim.api.nvim_command(command)
			end
		end)
	end
end

function M.godot_run_last()
	local command = string.format("silent! !%s %s", config.godot_path, config.last_scene)
	vim.api.nvim_command(command)
end

return M
