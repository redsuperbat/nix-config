---@module "lazy"
---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
      end,
      desc = "Format current buffer",
    },
  },
  --- @module "conform"
  --- @type conform.setupOpts
  opts = {
    format_on_save = {},
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandra" },
      tex = { "tex-fmt" },
      go = { "gofmt" },
      php = { lsp_format = "prefer" },
      python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
      toml = { "taplo" },
      vue = { "prettier" },
      dart = { lsp_format = "prefer" },
      typst = { "typstyle" },
      css = { lsp_format = "prefer" },
      markdown = { "prettier", lsp_format = "fallback" },
      rust = { lsp_format = "prefer" },
      ruby = { "rubocop" },
      yaml = { "prettier", lsp_format = "fallback" },
      javascript = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome-check" },
      typescriptreact = { "biome-check" },
      json = { "biome", "prettier", lsp_format = "fallback", stop_after_first = true },
      fish = { "fish_indent" },
      terraform = { "terraform_fmt" },
      dockerfile = { lsp_format = "prefer" },
      sh = { "shfmt" },
      sql = { "sqlfluff" },
    },
  },
}
