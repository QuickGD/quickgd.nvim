local lspkind = vim.lsp.protocol.CompletionItemKind

return {
	{ label = "struct", kind = lspkind.Keyword },
	{ label = "const", kind = lspkind.Keyword },
	{ label = "uniform", kind = lspkind.Keyword },
	{ label = "varying", kind = lspkind.Keyword },
	{ label = "lowp", kind = lspkind.Keyword },
	{ label = "mediump", kind = lspkind.Keyword },
	{ label = "highp", kind = lspkind.Keyword },
	{ label = "shader_type", kind = lspkind.Keyword },
	{ label = "render_mode", kind = lspkind.Keyword },
	{ label = "group_uniforms", kind = lspkind.Keyword },
}
