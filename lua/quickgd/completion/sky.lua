local lspkind = vim.lsp.protocol.CompletionItemKind

return {
	render_mode = {
		{ label = "use_half_res_pass", kind = lspkind.Module },
		{ label = "use_quarter_res_pass", kind = lspkind.Module },
		{ label = "disable_fog", kind = lspkind.Module },
	},
	global = {
		{ label = "POSITION", kind = lspkind.Constant },
		{ label = "RADIANCE", kind = lspkind.Constant },
		{ label = "AT_HALF_RES_PASS", kind = lspkind.Constant },
		{ label = "AT_QUARTER_RES_PASS", kind = lspkind.Constant },
		{ label = "AT_CUBEMAP_PASS", kind = lspkind.Constant },
		{ label = "LIGHTX_ENABLED", kind = lspkind.Constant },
		{ label = "LIGHTX_ENERGY", kind = lspkind.Constant },
		{ label = "LIGHTX_DIRECTION", kind = lspkind.Constant },
		{ label = "LIGHTX_COLOR", kind = lspkind.Constant },
		{ label = "LIGHTX_SIZE", kind = lspkind.Constant },
	},
	sky_in = {
		{ label = "EYEDIR", kind = lspkind.Constant },
		{ label = "SCREEN_UV", kind = lspkind.Constant },
		{ label = "SKY_COORDS", kind = lspkind.Constant },
		{ label = "HALF_RES_COLOR", kind = lspkind.Constant },
		{ label = "QUARTER_RES_COLOR", kind = lspkind.Constant },
	},
	sky_out = {
		{ label = "COLOR", kind = lspkind.Propery },
		{ label = "ALPHA", kind = lspkind.Propery },
		{ label = "FOG", kind = lspkind.Propery },
	},
}
