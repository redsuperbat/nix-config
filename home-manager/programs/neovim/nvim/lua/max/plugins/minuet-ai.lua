local fs = require("max.utils.fs")
local file_path = vim.fn.expand("~/.secrets/openai-api-key")

---@module "lazy"
---@type LazySpec
return {
  "milanglacier/minuet-ai.nvim",
  enabled = function()
    return fs.exists(file_path)
  end,
  event = "VeryLazy",
  config = function()
    require("minuet").setup({
      throttle = 200,
      provider = "openai",
      virtualtext = {
        show_on_completion_menu = true,
        auto_trigger_ft = { "*" },
        keymap = {
          accept = "<Tab>",
          prev = "<C-p>",
          next = "<C-n>",
          dismiss = "<C-e>",
        },
      },
      provider_options = {
        openai = {
          api_key = function()
            local lines = vim.fn.readfile(file_path)
            return vim.trim(table.concat(lines, "\n"))
          end,
        },
      },
    })
  end,
}
