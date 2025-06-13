---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  root_markers = {
    "Cargo.toml",
  },
}
