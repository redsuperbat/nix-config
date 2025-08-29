--- @brief
---
--- https://github.com/oxc-project/oxc
---
--- `oxc` is a linter / formatter for JavaScript / Typescript supporting over 500 rules from ESLint and its popular plugins
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxlint
--- ```

---@type vim.lsp.Config
return {
  cmd = { "oxc_language_server" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local dir = vim.fs.root(bufnr, { ".oxlintrc.json" })
    if not dir then
      return
    end
    on_dir(dir)
  end,
}
