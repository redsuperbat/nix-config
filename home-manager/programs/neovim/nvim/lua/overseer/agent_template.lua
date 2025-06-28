---@module "overseer"
local M = {}

---@class AgentParams
---@field initial_prompt string

---@class DefinitionOpts
---@field name string
---@field cmd fun(params: AgentParams):string
---@field env table<string,string|nil>?
---@field desc string

---@param opts DefinitionOpts
---@return overseer.TemplateDefinition
function M.definition(opts)
  ---@type overseer.TemplateDefinition
  return {
    name = opts.name,
    builder = function(params)
      ---@type overseer.TaskDefinition
      return {
        cmd = opts.cmd(params),
        cwd = vim.fn.getcwd(),
        metadata = params,
        env = opts.env,
        components = {
          "float.close_on_exit",
          "agent.on_input_requested",
          { "on_complete_dispose", timeout = 1 },
        },
      }
    end,
    params = { initial_prompt = { type = "string" } },
    desc = opts.desc,
  }
end

return M
