---@module "lazy"
---@type LazySpec
return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  keys = {
    {
      "<leader>q",
      function()
        require("quicker").toggle({ focus = true })
      end,
      { desc = "Toggle quick-fix list" },
    },
  },
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
}
