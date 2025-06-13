---@module "lazy"
---@type LazySpec
return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-treesitter/nvim-treesitter", lazy = true },
  { "echasnovski/mini.diff", lazy = true, opts = {}, version = "*" },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function()
      require("codecompanion").setup({
        display = {
          diff = {
            layout = "horizontal",
            provider = "mini_diff",
          },
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = "cmd:cat ~/.secrets/openai-api-key",
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "openai",
          },
          inline = {
            adapter = "openai",
          },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", {
        desc = "Code companion actions",
        silent = true,
        noremap = true,
      })
      vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", {
        noremap = true,
        silent = true,
        desc = "Toggle code companion chat",
      })
      vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
}
