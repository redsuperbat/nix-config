local M = {}
---@class FloatOpts
---@field on_close? fun()

local augroup = "MaxOverseerFloat"

--- Last size we pushed to each PTY, keyed by job id.
---@type table<integer, {[1]: integer, [2]: integer}>
local pty_size = {}

--- Sync the jobstart PTY size to the float window dimensions.
---
--- Overseer starts tasks while the terminal buffer is still hidden, so the PTY keeps
--- whatever size it was created with until something resizes it -- hence this sync.
--- Skip the call when the size already matches: every jobresize sends SIGWINCH, and a
--- TUI like lazygit responds by redrawing from scratch, which shows up as a flash.
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

  local last = pty_size[job_id]
  if last and last[1] == width and last[2] == height then
    return
  end
  if pcall(vim.fn.jobresize, job_id, width, height) then
    pty_size[job_id] = { width, height }
  end
end

---@module "overseer"
--- Note: do not pass this straight to overseer.run_task as the callback -- that is
--- called as fun(task, err), so the error string would land in `opts`.
---@param task overseer.Task|nil nil when the task failed to launch
---@param opts FloatOpts?
function M.enter(task, opts)
  if not task then
    return
  end
  local on_close = opts and opts.on_close

  -- Drop cached sizes for jobs that have since exited (jobwait returns -3 when invalid)
  for job_id in pairs(pty_size) do
    if vim.fn.jobwait({ job_id }, 0)[1] ~= -1 then
      pty_size[job_id] = nil
    end
  end

  task:open_output("float")
  local bufnr = task:get_bufnr()
  if bufnr then
    local win_id = vim.fn.bufwinid(bufnr)

    if win_id ~= -1 then
      -- A TUI repositions the cursor constantly while redrawing, and a non-zero
      -- scrolloff makes Neovim scroll the view to follow it -- so lazygit jitters.
      -- nvim_open_win's style="minimal" does not reset these. See neovim/neovim#11072.
      vim.api.nvim_set_option_value("scrolloff", 0, { scope = "local", win = win_id })
      vim.api.nvim_set_option_value("sidescrolloff", 0, { scope = "local", win = win_id })

      -- open_output already ran overseer's scroll_to_end, which parks the cursor at the
      -- end of the last line while the global sidescrolloff was still in effect. On
      -- reopen the buffer holds a full-width frame, so the view is left scrolled right
      -- and lazygit renders shifted off the left edge. Undo it now that the window exists.
      vim.api.nvim_win_call(win_id, function()
        local lnum = vim.api.nvim_win_get_cursor(win_id)[1]
        vim.api.nvim_win_set_cursor(win_id, { lnum, 0 })
        vim.fn.winrestview({ leftcol = 0 })
      end)

      sync_pty_size(task, win_id)
      vim.defer_fn(function()
        sync_pty_size(task, win_id)
      end, 50)

      -- Keep PTY in sync when the editor (and thus the float) resizes. Re-created per
      -- float, so clear the previous one instead of accumulating a callback per open.
      vim.api.nvim_create_autocmd("VimResized", {
        group = vim.api.nvim_create_augroup(augroup, { clear = true }),
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
    vim.keymap.set("t", "<C-q>", function()
      vim.cmd.close()
      if on_close then
        on_close()
      end
    end, {
      buffer = bufnr,
    })
  end
end

return M
