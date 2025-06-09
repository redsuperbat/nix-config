---@type vim.lsp.Config
return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = {
    "css",
    "graphql",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  root_dir = function(buf, cb)
    local found = vim.fs.root(buf, { "biome.json" })
    if found == nil then
      return
    end
    cb(found)
  end,
}
