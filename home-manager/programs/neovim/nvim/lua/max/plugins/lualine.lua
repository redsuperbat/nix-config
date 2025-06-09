---@module "lazy"
---@type LazySpec
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local auto = require("lualine.themes.auto")
      auto.normal.c.bg = "#1f1f28"
      require("lualine").setup({
        options = {
          theme = auto,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
          },
          lualine_c = {
            {
              "searchcount",
              maxcount = 999,
              timeout = 500,
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = "", -- Text to show when the file is modified.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "󰎔", -- Text to show for newly created file before first write
              },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
