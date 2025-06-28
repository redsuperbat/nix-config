local active_agents = require("overseer.active_agents")
---@module "overseer"

---@param task overseer.Task
local function is_current_buffer(task)
  local bufnr = task:get_bufnr()
  return bufnr == vim.api.nvim_get_current_buf()
end

---@module "overseer"
---@type overseer.ComponentDefinition
return {
  name = "on_input_requested",
  editable = false,
  desc = "Send notification if input is requested from agent",
  constructor = function()
    local timer = vim.uv.new_timer()
    if not timer then
      return {}
    end
    ---@type overseer.ComponentSkeleton
    return {
      ---@param task overseer.Task
      on_output_lines = function(_, task)
        timer:stop()
        if is_current_buffer(task) then
          return
        end
        timer:start(
          5000,
          0,
          vim.schedule_wrap(function()
            timer:stop()
            if is_current_buffer(task) then
              return
            end
            ---@type AgentParams | nil
            local meta = task.metadata
            local task_name = meta and meta.initial_prompt or task.name
            require("snacks").notifier.notify("AI Task: " .. task_name, "info", {
              icon = "󰧑",
              timeout = 15000,
              title = "AI Requesting input",
            })
            active_agents.add_agent(task)
          end)
        )
      end,
      on_exit = function()
        timer:stop()
      end,
    }
  end,
}
