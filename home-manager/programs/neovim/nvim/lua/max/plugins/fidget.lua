---@module "lazy"
---@type LazySpec
return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    progress = {
      display = {
        done_ttl = 3,
        done_icon = "✔",
        progress_icon = { pattern = "dots" },
      },
    },
    notification = {
      window = {
        winblend = 0,
      },
    },
  },
}
