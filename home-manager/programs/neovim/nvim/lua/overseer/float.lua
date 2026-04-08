local M = {}
---@class FloatOpts
---@field on_close? fun()

--- Sync the jobstart PTY size to the float window dimensions.
---@param task overseer.Task
---@param win_id integer
local function sync_pty_size(task, win_id)
  local job_id = task.strategy and task.strategy.job_id
  if not job_id then
    return
  end
  local ok, width = pcall(vim.api.nvim_win_get_width, win_id)
  if not ok then
    return
  end
  local height = vim.api.nvim_win_get_height(win_id)
  pcall(vim.fn.jobresize, job_id, width, height)
end

---@module "overseer"
---@param task overseer.Task
---@param opts FloatOpts?
function M.enter(task, opts)
  local on_close = opts and opts.on_close

  task:open_output("float")
  local bufnr = task:get_bufnr()
  if bufnr then
    local win_id = vim.fn.bufwinid(bufnr)

    if win_id ~= -1 then
      sync_pty_size(task, win_id)
      vim.defer_fn(function()
        sync_pty_size(task, win_id)
      end, 50)

      -- Keep PTY in sync when the editor (and thus the float) resizes
      vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
          if not vim.api.nvim_win_is_valid(win_id) then
            return true -- delete autocmd
          end
          sync_pty_size(task, win_id)
        end,
      })
    end

    vim.schedule(function()
      vim.cmd("startinsert!")
    end)
    vim.keymap.set("t", "<esc><esc>", function()
      vim.cmd.close()
      if type(on_close) == "function" then
        on_close()
      end
    end, {
      buffer = bufnr,
    })
  end
end

return M
