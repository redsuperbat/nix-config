---@module "lazy"
---@type LazySpec
return {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
  version = "v1.6.0",
  config = function()
    local overseer = require("overseer")
    overseer.setup({ task_win = { padding = 3, border = "none" } })

    overseer.register_template(require("overseer.template.lazygit.default"))
    overseer.register_template(require("overseer.template.lazygit.reflog"))
    overseer.register_template(require("overseer.template.lnav.default"))
  end,
}
