local M = {}
---@class FloatOpts
---@field on_close? fun()
---@field with_esc? boolean

---@module "overseer"
---@param task overseer.Task
---@param opts FloatOpts?
function M.enter(task, opts)
  local with_esc = opts and opts.with_esc
  local on_close = opts and opts.on_close

  require("overseer").run_action(task, "open float")
  vim.schedule(function()
    vim.cmd("startinsert!")
  end)
  if with_esc == false then
    return
  end
  vim.keymap.set("t", "<esc><esc>", function()
    vim.cmd.close()
    if on_close then
      on_close()
    end
  end, {
    buffer = task:get_bufnr(),
  })
end

return M
