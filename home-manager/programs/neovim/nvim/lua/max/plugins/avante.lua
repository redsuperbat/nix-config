local fs = require("max.utils.fs")
---@module "lazy"
---@type LazySpec
return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  enabled = false,
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "openai",
    providers = {
      openai = {
        parse_api_key = function()
          return fs.read_file("~/.secrets/openai-api-key")
        end,
      },
    },
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = false,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
      auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
    },
  },
}
