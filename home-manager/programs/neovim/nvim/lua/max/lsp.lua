--- This code enables all language servers
--- with configuration in the lsp directory
local lsp_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lsp")
--- @type string[]
local language_servers_to_enable = {}
for filename in vim.fs.dir(lsp_dir) do
  local lsp_name = filename:gsub("%.lua$", "")
  if filename:match("%.lua$") then
    table.insert(language_servers_to_enable, lsp_name)
  end
end
vim.lsp.enable(language_servers_to_enable)

vim.api.nvim_create_user_command("LspClearLog", function()
  vim.cmd(string.format("!echo -n > %s", vim.lsp.get_log_path()))
end, { desc = "Clear lsp logs" })

vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", {
  desc = "Language server info",
})

vim.keymap.set("n", "<leader>lr", ":lsp restart<CR>", { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>gd", function()
  vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 })
end, { desc = "Jump to next diagnostic" })
