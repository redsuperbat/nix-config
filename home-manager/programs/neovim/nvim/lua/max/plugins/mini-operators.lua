---@module "lazy"
---@type LazySpec
return {
  "echasnovski/mini.operators",
  version = "*",
  event = "VeryLazy",
  opts = {
    -- Evaluate text and replace with output
    evaluate = { prefix = "g=" },
    -- Exchange text regions
    exchange = { prefix = "gx" },
    -- Multiply (duplicate) text
    multiply = { prefix = "gm" },
    -- Sort text
    sort = { prefix = "gs" },
    -- Keep substitute.nvim and don't override 'gr' go to reference
    replace = { prefix = "" },
  },
}
