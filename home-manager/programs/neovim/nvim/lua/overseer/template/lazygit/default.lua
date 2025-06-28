---@module "overseer"
local float = require("overseer.float")
local name = "lazygit"
local desc = "Launches lazygit"

local function open_task_if_exists()
  local overseer = require("overseer")

  ---@type overseer.Task|nil
  local task = overseer.list_tasks({ name = name })[1]

  if not task then
    return overseer.run_template({ name = name }, float.enter)
  end

  if not task:is_running() then
    return overseer.run_template({ name = name }, float.enter)
  end

  float.enter(task)
end

vim.keymap.set("n", "<leader>gg", open_task_if_exists, { desc = desc })

---@type overseer.TemplateDefinition
return {
  name = name,
  builder = function()
    ---@type overseer.TaskDefinition
    return {
      cmd = name,
      cwd = vim.fn.getcwd(),
      components = { "unique", "float.close_on_exit" },
    }
  end,
  desc = desc,
}
