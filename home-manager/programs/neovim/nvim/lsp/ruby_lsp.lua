---@type vim.lsp.Config
return {
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  init_options = {
    formatter = false,
  },
  root_markers = {
    "Gemfile",
  },
}
