---@module "lazy"
---@type LazySpec
return {
  "echasnovski/mini.surround",
  version = "*",
  event = "VeryLazy",
  opts = {
    mappings = {
      add = "sa", -- Add surrounding in Normal and Visual modes
      delete = "sd", -- Delete surrounding
      highlight = "sh", -- Highlight surrounding
      replace = "sr", -- Replace surrounding
    },
  },
}
