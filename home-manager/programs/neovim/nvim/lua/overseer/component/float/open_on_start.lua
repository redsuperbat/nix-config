local float = require("overseer.float")
---@module "overseer"
---@type overseer.ComponentDefinition
return {
  name = "open_on_start",
  editable = false,
  desc = "Enters a float when the task starts",
  constructor = function()
    ---@type overseer.ComponentSkeleton
    return {
      on_pre_start = function(_, task)
        vim.schedule(function()
          float.enter(task)
        end)
      end,
    }
  end,
}
