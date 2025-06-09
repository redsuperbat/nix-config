---@module "lazy"
---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      map({ "n", "v" }, "<leader>gp", ":Gitsigns preview_hunk<CR>", "Preview Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map({ "n", "v" }, "<leader>gbs", ":Gitsigns stage_buffer<CR>", "Stage buffer")
      map({ "n", "v" }, "<leader>gbr", ":Gitsigns reset_buffer<CR>", "Reset buffer")

      map("n", "<leader>gc", function()
        vim.schedule(function()
          gs.next_hunk()
        end)
      end, "Go to next change")
    end,
  },
}
