local lspkind = vim.lsp.protocol.CompletionItemKind

return {
	render_mode = {
		{ label = "keep_data", kind = lspkind.Module },
		{ label = "disable_force", kind = lspkind.Module },
		{ label = "disable_velocity", kind = lspkind.Module },
	},
	global_in = {
		{ label = "LIFETIME", kind = lspkind.Constant },
		{ label = "DELTA", kind = lspkind.Constant },
		{ label = "NUMBER", kind = lspkind.Constant },
		{ label = "INDEX", kind = lspkind.Constant },
		{ label = "EMISSION_TRANSFORM", kind = lspkind.Constant },
		{ label = "RANDOM_SEED", kind = lspkind.Constant },
	},
	global_inout = {
		{ label = "ACTIVE", kind = lspkind.Property },
		{ label = "COLOR", kind = lspkind.Property },
		{ label = "VELOCITY", kind = lspkind.Property },
		{ label = "TRANSFORM", kind = lspkind.Property },
		{ label = "CUSTOM", kind = lspkind.Property },
		{ label = "MASS", kind = lspkind.Property },
	},
	start_in = {

		{ label = "RESTART_POSITION", kind = lspkind.Constant },
		{ label = "RESTART_ROT_SCALE", kind = lspkind.Constant },
		{ label = "RESTART_VELOCITY", kind = lspkind.Constant },
		{ label = "RESTART_COLOR", kind = lspkind.Constant },
		{ label = "RESTART_CUSTOM", kind = lspkind.Constant },
	},
	process_in = {

		{ label = "RESTART", kind = lspkind.Constant },
		{ label = "FLAG_EMIT_POSITION", kind = lspkind.Constant },
		{ label = "FLAG_EMIT_ROT_SCALE", kind = lspkind.Constant },
		{ label = "FLAG_EMIT_VELOCITY", kind = lspkind.Constant },
		{ label = "FLAG_EMIT_COLOR", kind = lspkind.Constant },
		{ label = "FLAG_EMIT_CUSTOM", kind = lspkind.Constant },
		{ label = "COLLIDED", kind = lspkind.Constant },
		{ label = "COLLISION_NORMAL", kind = lspkind.Constant },
		{ label = "COLLISION_DEPTH", kind = lspkind.Constant },
		{ label = "ATTRACTOR_FORCE", kind = lspkind.Constant },
	},

	process_functions = {
		{ label = "emit_subparticle", kind = lspkind.Function },
	},
}
