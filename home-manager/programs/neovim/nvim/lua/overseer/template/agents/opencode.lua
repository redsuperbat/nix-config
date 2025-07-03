---@module "overseer"
local fs = require("max.utils.fs")
local agent_template = require("overseer.agent_template")

local name = "opencode"

return agent_template.definition({
  name = name,
  cmd = name,
  desc = "Launches opencode",
  env = { OPENAI_API_KEY = fs.read_file("~/.secrets/openai-api-key") },
})
