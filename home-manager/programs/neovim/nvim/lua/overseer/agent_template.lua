---@module "overseer"
local M = {}

---@class AgentParams
---@field initial_prompt string
---@field is_agent true

---@class DefinitionOpts
---@field name string
---@field cmd string
---@field env table<string,string|nil>?
---@field components string[]?
---@field desc string

---@param opts DefinitionOpts
---@return overseer.TemplateDefinition
function M.definition(opts)
  ---@type overseer.TemplateDefinition
  return {
    name = opts.name,
    ---@param params AgentParams
    builder = function(params)
      local metadata = { is_agent = true }
      for k, v in pairs(params) do
        metadata[k] = v
      end
      ---@type overseer.TaskDefinition
      return {
        cmd = opts.cmd,
        cwd = vim.fn.getcwd(),
        metadata = metadata,
        env = opts.env,
        components = {
          "float.close_on_exit",
          "float.open_on_start",
          "agent.on_input_requested",
          { "on_complete_dispose", timeout = 1 },
          unpack(opts.components or {}),
          "default",
        },
      }
    end,
    desc = opts.desc,
  }
end

return M
