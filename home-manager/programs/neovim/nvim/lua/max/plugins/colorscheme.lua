---@module "lazy"
---@type LazySpec
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- wave the default heart-warming theme,
    -- dragon for those late-night sessions
    -- lotus for when you're out in the open.
    require("kanagawa").load("wave")
  end,
}
