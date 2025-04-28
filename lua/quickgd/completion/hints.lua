local lspkind = vim.lsp.protocol.CompletionItemKind

return {
	{ label = "source_color", kind = lspkind.Event },
	{ label = "hint_enum", kind = lspkind.Event },
	{ label = "hint_range(0,1,0.1)", kind = lspkind.Event },
	{ label = "hint_normal", kind = lspkind.Event },
	{ label = "hint_default_white", kind = lspkind.Event },
	{ label = "hint_default_black", kind = lspkind.Event },
	{ label = "hint_default_transparent", kind = lspkind.Event },
	{ label = "hint_anisotropy", kind = lspkind.Event },
	{ label = "hint_roughness", kind = lspkind.Event },
	{ label = "filter", kind = lspkind.Event },
	{ label = "repeat", kind = lspkind.Event },
	{ label = "hint_screen_texture", kind = lspkind.Event },
	{ label = "hint_depth_texture", kind = lspkind.Event },
	{ label = "hint_normal_roughness_texture", kind = lspkind.Event },
}
