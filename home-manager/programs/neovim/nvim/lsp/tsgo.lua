local shebang = require("max.utils.shebang")

---@type vim.lsp.Config
return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_dir = function(buf, cb)
    if shebang.is_deno(buf) then
      return
    end
    local found = vim.fs.root(buf, {
      "package.json",
      "tsconfig.json",
      ".git",
    })
    cb(found)
  end,
}
