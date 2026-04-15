---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    local root = vim.fs.root(0, { "biome.json", "biome.jsonc" }) or vim.fn.getcwd()
    local local_biome = root .. "/node_modules/.bin/biome"
    local bin = vim.uv.fs_stat(local_biome) and local_biome or "biome"
    return vim.lsp.rpc.start({ bin, "lsp-proxy" }, dispatchers)
  end,
  filetypes = {
    "css",
    "graphql",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
  root_dir = function(buf, cb)
    local found = vim.fs.root(buf, { "biome.json", "biome.jsonc" })
    if found == nil then
      return
    end
    cb(found)
  end,
}
