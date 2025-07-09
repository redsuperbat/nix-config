local M = {}
---@class FloatOpts
---@field on_close? fun()

---@module "overseer"
---@param task overseer.Task
---@param opts FloatOpts?
function M.enter(task, opts)
  local on_close = opts and opts.on_close

  require("overseer").run_action(task, "open float")
  vim.schedule(function()
    vim.cmd("startinsert!")
  end)
  vim.keymap.set("t", "<esc><esc>", function()
    vim.cmd.close()
    if type(on_close) == "function" then
      on_close()
    end
  end, {
    buffer = task:get_bufnr(),
  })
end

return M
