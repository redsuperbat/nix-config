vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "prisma_ls" then
      return
    end

    local orig = client.request
    client.request = function(self, method, params, ...)
      if method == "textDocument/formatting" then
        params.options = params.options or {}
        params.options.tabSize = 2
        params.options.insertSpaces = true
      end
      return orig(self, method, params, ...)
    end
  end,
})

---@type vim.lsp.Config
return {
  cmd = { "npx", "--yes", "@prisma/language-server", "--stdio" },
  filetypes = { "prisma" },
  root_markers = { ".git", "package.json" },
  settings = {
    prisma = {
      prismaFmtBinPath = "",
    },
  },
}
