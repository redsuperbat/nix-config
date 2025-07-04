local shebang = require("max.utils.shebang")

---@type vim.lsp.Config
return {
  cmd = { "deno", "lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "deno.json",
  },
  root_dir = function(buf, cb)
    if shebang.is_deno(buf) then
      return cb(vim.api.nvim_buf_get_name(buf))
    end
    local found = vim.fs.root(buf, { "deno.json" })
    if found == nil then
      return
    end
    cb(found)
  end,
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
}
