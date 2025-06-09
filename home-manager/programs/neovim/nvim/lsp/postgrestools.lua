---@type vim.lsp.Config
return {
  cmd = { "postgrestools", "lsp-proxy" },
  filetypes = { "sql" },
  root_dir = function(buf, cb)
    local found = vim.fs.root(buf, { "postgrestools.jsonc" })
    if found == nil then
      return
    end
    cb(found)
  end,
}
