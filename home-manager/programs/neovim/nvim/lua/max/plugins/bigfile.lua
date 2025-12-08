---@module "lazy"
---@type LazySpec
return {
  "LunarVim/bigfile.nvim",
  lazy = false,
  config = function()
    require("bigfile").setup({
      filesize = 1, -- MiB
      pattern = {"*"},
      features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    })
  end,
}
