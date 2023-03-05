local M = {}

M.default = {
  godot_location = vim.fs.normalize(os.getenv("GODOT") or ""),
  last_scene = "",
  telescope = true,
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
