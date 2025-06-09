---@module "lazy"
---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Github actions
        null_ls.builtins.diagnostics.actionlint,
        -- Dockerfile
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }),
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.diagnostics.fish,
      },
    })
  end,
}
