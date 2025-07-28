---@module "overseer"
local float = require("overseer.float")
local name = string.format("lnav %s", vim.lsp.get_log_path())
local desc = "Open LSP log in terminal with lnav"

vim.api.nvim_create_user_command("LspLog", function()
  local overseer = require("overseer")
  return overseer.run_template({ name = name }, float.enter)
end, { desc = desc })

---@type overseer.TemplateDefinition
return {
  name = name,
  builder = function()
    ---@type overseer.TaskDefinition
    return {
      cmd = name,
      cwd = vim.fn.getcwd(),
      components = { "unique", "float.close_on_exit", "default" },
    }
  end,
  desc = desc,
}
