---@module "lazy"
---@type LazySpec
return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = { backend = "tmux", enabled = true },
    },
  },
  event = "VeryLazy",
  keys = {
    {
      "<C-f>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<C-f>"
        end
      end,
      expr = false,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick  Switch Focus",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
}
