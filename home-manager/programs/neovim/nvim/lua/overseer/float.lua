local M = {}

---@module "overseer"
---@param task overseer.Task
---@param with_esc? boolean
function M.enter(task, with_esc)
  if with_esc == nil then
    with_esc = true
  end

  require("overseer").run_action(task, "open float")
  vim.cmd("startinsert!")
  if not with_esc then
    return
  end
  vim.keymap.set("t", "<esc><esc>", function()
    vim.cmd.close()
  end, {
    buffer = true,
  })
end

return M
