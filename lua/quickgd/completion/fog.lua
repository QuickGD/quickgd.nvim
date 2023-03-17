local lspkind = vim.lsp.protocol.CompletionItemKind

return {
	fog_in = {
		{ label = "WORLD_POSITION", kind = lspkind.Constant },
		{ label = "OBJECT_POSITION", kind = lspkind.Constant },
		{ label = "UVW", kind = lspkind.Constant },
		{ label = "EXTENTS", kind = lspkind.Constant },
		{ label = "SDF", kind = lspkind.Constant },
	},
	fog_out = {
		{ label = "ALBEDO", kind = lspkind.Property },
		{ label = "DENSITY", kind = lspkind.Property },
		{ label = "EMISSION", kind = lspkind.Property },
	},
}
