vim.filetype.add({
  pattern = {
    [".*.lis"] = "lis",
  },
})

---@type vim.lsp.Config
return {
  cmd = { "lis", "lsp" },
  filetypes = { "lis" },
  root_markers = { "lisette.toml" },
}
