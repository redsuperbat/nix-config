---@module "lazy"
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    {
      "<C-space>",
      function()
        local select = require("vim.treesitter._select")
        if vim.fn.mode() == "n" then
          vim.cmd("normal! v")
        end
        select.select_parent(vim.v.count1)
      end,
      desc = "Increment Selection",
      mode = { "n", "x" },
    },
    {
      "<bs>",
      function()
        require("vim.treesitter._select").select_child(vim.v.count1)
      end,
      desc = "Decrement Selection",
      mode = "x",
    },
  },
  config = function()
    require("nvim-treesitter").setup({
      auto_install = true,
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
