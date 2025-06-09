---@module "lazy"
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ignore_install = {},
      modules = {},
      sync_install = false,
      auto_install = true,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = false,
        },
      },
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "diff",
        "html",
        "rust",
        "javascript",
        "jsdoc",
        "json",
        "terraform",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    })
  end,
}
