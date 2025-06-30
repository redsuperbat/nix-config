local fs = require("max.utils.fs")
local agent_template = require("overseer.agent_template")
local name = "gemini"

return agent_template.definition({
  cmd = name,
  name = name,
  desc = "Launches gemini",
  components = { "float.open_on_start" },
  env = { GITHUB_PAT = fs.read_file("~/.secrets/mcp_github_pat") },
})
