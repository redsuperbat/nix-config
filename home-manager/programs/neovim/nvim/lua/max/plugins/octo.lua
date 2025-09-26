---@module "lazy"
---@type LazySpec
return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("octo").setup({
      picker = "snacks",
    })
  end,
}
