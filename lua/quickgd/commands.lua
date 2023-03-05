local M = {}

local util = require("quickgd.util")
local config = require("quickgd.config")
local telescope = require("quickgd.telescope")
local actions = telescope.actions
local actions_state = telescope.actions_state

local function run_scene(prompt_bufnr, map)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    config.last_scene = selected.path
    local command = string.format("silent! !%s %s", config.godot_location, selected.path)
    vim.api.nvim_command(command)
  end)
  return true
end

function M.godot_run()
  if config.telescope then
    telescope.run_func_on_selected({
      name = "TSCN",
      attach_mappings = run_scene,
      results = util.get_files_by_end,
      results_args = ".tscn",
    })
  else
    local list = util.get_files_by_end(".tscn", "false")
    vim.ui.select(list.name, {
      prompt = 'TSCN',
    }, function(_, index)
      if index ~= nil then
        config.last_scene = list.path[index]
        local command = string.format("silent! !%s %s", config.godot_location, list.path[index])
        vim.api.nvim_command(command)
      end
    end)
  end
end

function M.godot_run_last()
  local command = string.format("silent! !%s %s", config.godot_location, config.last_scene)
  vim.api.nvim_command(command)
end

return M