local keymap = vim.keymap.set

-- buffers
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Go to end of line and go to start of line
keymap({ "n", "v" }, "gl", "g_", { desc = "Go to end of line" })
keymap({ "n", "v" }, "gh", "^", { desc = "Go to start of line" })

-- Move line down (Normal mode): Alt + j
keymap("n", "<Down>", ":m .+1<CR>==")
-- Move line up (Normal mode): Alt + k
keymap("n", "<Up>", ":m .-2<CR>==")
-- Move selection down (Visual mode): Alt + j
keymap("v", "<Down>", ":m '>+1<CR>gv=gv")
-- Move selection up (Visual mode): Alt + k
keymap("v", "<Up>", ":m '<-2<CR>gv=gv")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- save file
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- new file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
keymap("n", "<leader>ft", function()
  require("max.utils.terminal").open({
    on_buf_create = function(buf)
      vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode", buffer = buf, nowait = true })
    end,
  })
end, { desc = "Floating terminal" })

-- Execute lua utils
keymap("n", "<leader>xx", "<cmd>source %<CR>", { desc = "Source current buffer file" })
keymap("n", "<leader>x", ":.lua<CR>", { desc = "Execute current line" })
keymap("v", "<leader>x", ":lua<CR>", { desc = "Execute current visual selection" })
