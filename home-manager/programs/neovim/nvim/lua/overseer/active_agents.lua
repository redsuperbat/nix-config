---@module "overseer"
local float = require("overseer.float")
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

function M.pop_enter()
  if #M.agents == 0 then
    return require("snacks").notifier.notify("No active agents")
  end
  local agent = M.agents[1]
  float.enter(agent, {
    on_close = function()
      M.remove_agent(agent.id)
    end,
  })
end

return M
