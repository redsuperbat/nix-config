local active_agents = require("overseer.active_agents")
---@module "overseer"
---@type overseer.ComponentDefinition
return {
  name = "close_on_exit",
  editable = false,
  desc = "Closes a float if it exists when the task exits",
  constructor = function()
    ---@type overseer.ComponentSkeleton
    return {
      on_exit = function(_, task)
        active_agents.remove_agent(task.id)
        vim.cmd.close()
      end,
    }
  end,
}
