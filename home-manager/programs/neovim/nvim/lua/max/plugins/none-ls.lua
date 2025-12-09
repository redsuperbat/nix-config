---@module "lazy"
---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.actionlint, -- Github actions
        null_ls.builtins.diagnostics.checkmake, -- Makefile linter
        null_ls.builtins.diagnostics.hadolint, -- Dockerfile
        null_ls.builtins.diagnostics.rubocop, -- Ruby linter
        null_ls.builtins.diagnostics.fish,
      },
    })
  end,
}
