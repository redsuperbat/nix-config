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
    local deno_json_found = vim.fs.root(buf, {
      "deno.json",
    })
    if deno_json_found ~= nil then
      return
    end
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
    local project_root = vim.fs.root(buf, root_markers)
    if not project_root then
      return
    end

    cb(project_root)
  end,
}
