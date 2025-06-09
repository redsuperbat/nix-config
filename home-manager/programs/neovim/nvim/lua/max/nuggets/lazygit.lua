local M = {}

--- @param filepath string
local function encode_fish_filepath(filepath)
  local encoded = filepath:gsub("([()%s!#$&'*;<=>?`{|}])", "\\%1")
  return encoded
end

--- @param cmd string
local function lazygit_term(cmd)
  require("max.utils.terminal").open({
    cmd = cmd,
    border = "none",
    on_buf_create = function(buf)
      -- Close window if lazyvim exits
      vim.api.nvim_create_autocmd("TermClose", {
        buffer = buf,
        callback = function()
          vim.cmd("close")
        end,
      })
    end,
  })
end

function M.open()
  lazygit_term("lazygit")
end

function M.reflog()
  local file = vim.trim(vim.api.nvim_buf_get_name(0))
  file = encode_fish_filepath(file)
  lazygit_term(string.format("lazygit -f %s", file))
end

vim.keymap.set("n", "<leader>gg", M.open, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gr", M.reflog, { desc = "Git buffer reflog" })

return M
