---@type vim.lsp.Config
return {
  name = "gopls",
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod", "gowork", "gotmpl", "golang" },
  root_markers = {
    "go.work",
    "go.mod",
    ".git",
  },
}
