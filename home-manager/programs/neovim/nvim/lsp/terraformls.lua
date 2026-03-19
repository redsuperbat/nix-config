---@type vim.lsp.Config
return {
  cmd = { "terraform-ls", "serve" },
  filetypes = {},
  root_markers = { ".terraform", ".git" },
}
