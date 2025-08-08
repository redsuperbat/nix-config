---@module "overseer"
---@class ActiveAgents
---@field agents table<number, overseer.Task>
local M = { agents = {} }

---@param task overseer.Task
function M.add_agent(task)
  table.insert(M.agents, task)
end

function M.remove_agent(task_id)
  M.agents = vim.tbl_filter(
    ---@param a overseer.Task
    function(a)
      return a.id ~= task_id
    end,
    M.agents
  )
end

--- @return overseer.Task | nil
function M.pop()
  if #M.agents == 0 then
    require("snacks").notifier.notify("No active agents")
    return
  end
  local agent = M.agents[1]
  M.remove_agent(agent.id)
  return agent
end

return M
