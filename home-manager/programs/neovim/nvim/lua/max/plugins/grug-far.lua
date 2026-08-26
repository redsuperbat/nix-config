---@module "lazy"
---@type LazySpec
return {
  "MagicDuck/grug-far.nvim",
  opts = {
    engines = {
      ripgrep = {
        extraArgs = "--hidden --glob !.git/",
      },
    },
  },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open()
      end,
    },
  },
}
