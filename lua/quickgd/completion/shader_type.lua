local lspkind = vim.lsp.protocol.CompletionItemKind

return {
  { label = "canvas_item", kind = lspkind.Module },
  { label = "spatial", kind = lspkind.Module },
  { label = "particles", kind = lspkind.Module },
  { label = "sky", kind = lspkind.Module },
  { label = "fog", kind = lspkind.Module },
}
