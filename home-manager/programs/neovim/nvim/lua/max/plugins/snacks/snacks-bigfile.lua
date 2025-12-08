---@module "lazy"
---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    bigfile = {
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5MB
      line_length = 1000, -- average line length (for minified files)
    },
  },
}
