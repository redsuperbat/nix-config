---@module "overseer"
local fs = require("max.utils.fs")
local agent_template = require("overseer.agent_template")

local name = "codex"

return agent_template.definition({
  name = name,
  cmd = name,
  desc = "Launches codex",
  env = { OPENAI_API_KEY = fs.read_file("~/.secrets/openai-api-key") },
})
