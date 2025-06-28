local agent_template = require("overseer.agent_template")
local name = "claude"

return agent_template.definition({
  name = name,
  cmd = function()
    return name
  end,
  desc = "Launches claude",
})
