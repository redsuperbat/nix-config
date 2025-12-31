vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("OutputPanel")
end, {
  desc = "Open lsp logs",
})

---@module "lazy"
---@type LazySpec
return {
  "mhanberg/output-panel.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("output_panel").setup({})
  end,
  cmd = "OutputPanel",
}
