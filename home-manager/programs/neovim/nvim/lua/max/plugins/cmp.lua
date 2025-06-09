---@module "lazy"
---@type LazySpec
return {
  { "hrsh7th/cmp-cmdline", lazy = true },
  {
    "hrsh7th/nvim-cmp",
    event = { "BufEnter" },
    opts = {},
  },
}
