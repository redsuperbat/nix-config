---@module "lazy"
---@type LazySpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>mw",
      function()
        require("render-markdown").toggle()
      end,
      { desc = "Toggle render markdown" },
    },
  },
  ft = { "md", "markdown", "codecompanion" },
  ---@module "render-markdown"
  ---@type render.md.UserConfig
  opts = {},
  init = function()
    require("max.utils.theme").set_bg("RenderMarkdownCode")
  end,
}
