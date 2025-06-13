---@module "lazy"
---@type LazySpec
return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  version = "*",
  config = function()
    local spec_treesitter = require("mini.ai").gen_spec.treesitter
    require("mini.ai").setup({
      custom_textobjects = {
        -- Disable brackets alias in favor of builtin block textobject
        b = false,
        -- Allow to select inside and outside of function nodes
        f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
        d = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
      },
    })
  end,
}
