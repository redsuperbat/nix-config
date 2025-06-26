local float = require("max.nuggets.overseer_float")

---@module "overseer"
---@type overseer.ComponentDefinition
return {
  name = "on_input_requested",
  editable = false,
  desc = "Focus the job if input is requested",
  constructor = function()
    local timer = vim.loop.new_timer()
    return {
      ---@param task overseer.Task
      on_output_lines = function(_, task)
        timer:stop()
        timer:start(
          5000,
          0,
          vim.schedule_wrap(function()
            timer:stop()
            local bufnr = task:get_bufnr()
            if not bufnr then
              return
            end
            if bufnr == vim.api.nvim_get_current_buf() then
              return
            end
            float.enter(task)
          end)
        )
      end,
      on_exit = function()
        timer:stop()
      end,
    }
  end,
}
