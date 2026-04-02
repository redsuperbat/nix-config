---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    lazy = false,
  },
  {
    "lewis6991/ts-install.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    config = function()
      require("ts-install").setup({
        auto_install = true,
      })

      vim.keymap.set({ "n", "x" }, "<C-space>", function()
        local select = require("vim.treesitter._select")
        if vim.fn.mode() == "n" then
          vim.cmd("normal! v")
        end
        select.select_parent(vim.v.count1)
      end, { desc = "Increment Selection" })

      vim.keymap.set("x", "<bs>", function()
        require("vim.treesitter._select").select_child(vim.v.count1)
      end, { desc = "Decrement Selection" })
    end,
  },
}
