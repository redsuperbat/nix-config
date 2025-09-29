---@module "overseer"
---@type overseer.ComponentDefinition
return {
  name = "close_on_exit",
  editable = false,
  desc = "Closes a float if it exists when the task exits",
  constructor = function()
    ---@type overseer.ComponentSkeleton
    return {
      on_exit = function()
        vim.cmd.close()
      end,
    }
  end,
}
