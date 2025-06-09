---@module "lazy"
---@type LazySpec
return {
  "ggandor/leap.nvim",
  dependencies = { "tpope/vim-repeat" },
  keys = {
    {
      "m",
      "<Plug>(leap-forward)",
      desc = "Leap forwards",
    },
    {
      "M",
      "<Plug>(leap-backward)",
      desc = "Leap backwards",
    },
  },
}
