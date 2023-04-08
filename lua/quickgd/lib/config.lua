local M = {}

M.default = {
	godot_path = vim.fs.normalize(os.getenv("GODOT") or ""),
	project_path = vim.fs.normalize(vim.fn.getcwd()) .. "/project.godot",
	last_scene = "",
	telescope = true,
	treesitter = true,
	cmp = true,
}

function M.set_user_config(opts)
	opts = opts or {}

	if opts.default then
		error("User values are not stored in 'default'")
	end
	opts = vim.tbl_deep_extend("force", M.default, opts)
	for key, value in pairs(opts) do
		M[key] = value
	end
end

return M
