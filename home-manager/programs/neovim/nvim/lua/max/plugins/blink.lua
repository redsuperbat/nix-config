---@module "lazy"
---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    lazy = true,
    ft = "lua", -- only load on lua files
    dependencies = { "Bilal2453/luvit-meta" },
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip").filetype_extend("typescriptreact", { "html" })
          require("luasnip").filetype_extend("javascriptreact", { "html" })
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "saghen/blink.cmp",
    event = { "BufEnter" },
    version = "v0.*",
    config = function()
      require("blink.cmp").setup({
        enabled = function()
          -- Disable in code-actions and code-renames
          local disabled_filetypes = {
            "snacks_picker_input",
            "snacks_input",
            "neo-tree-popup",
          }
          return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
        end,
        keymap = {
          preset = "default",
          ["<CR>"] = { "select_and_accept", "fallback" },
        },
        cmdline = {
          enabled = false,
        },
        snippets = {
          preset = "luasnip",
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "markdown", "lazydev" },
          providers = {
            markdown = {
              name = "RenderMarkdown",
              module = "render-markdown.integ.blink",
            },
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              score_offset = 150, -- the higher the number, the higher the priority
              min_keyword_length = 0, -- Number of characters to trigger provider
            },
            path = {
              name = "Path",
              module = "blink.cmp.sources.path",
              score_offset = 25,
              opts = {
                trailing_slash = false,
                label_trailing_slash = true,
              },
            },
            snippets = {
              name = "Snippets",
              module = "blink.cmp.sources.snippets",
              min_keyword_length = 1,
              score_offset = 60,
            },
            buffer = {
              name = "Buffer",
              module = "blink.cmp.sources.buffer",
              min_keyword_length = 3,
              score_offset = 15, -- the higher the number, the higher the priority
            },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
            },
          },
        },
        appearance = {
          kind_icons = {
            Text = "󰉿",
            Method = "",
            Function = "󰊕",
            Constructor = "󰒓",

            Field = "󰜢",
            Variable = "󰆦",
            Property = "󰖷",

            Class = "",
            Interface = "",
            Struct = "",
            Module = "󰅩",

            Unit = "󰪚",
            Value = "󰦨",
            Enum = "",
            EnumMember = "󰦨",

            Keyword = "󰻾",
            Constant = "󰏿",

            Snippet = "󱄽",
            Color = "󰏘",
            File = "󰈔",
            Reference = "󰬲",
            Folder = "󰉋",
            Event = "󱐋",
            Operator = "󰪚",
            TypeParameter = "󰬛",
          },
          nerd_font_variant = "mono",
        },
        completion = {
          -- Ghost-text breaks sometimes
          ghost_text = { enabled = false },
          menu = {
            border = "rounded",
            draw = {
              columns = {
                {
                  "kind_icon",
                  "label",
                  gap = 2,
                },
                {
                  "label_description",
                  gap = 5,
                  "kind",
                },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            treesitter_highlighting = true,
            window = { border = "rounded" },
          },
        },
        signature = { enabled = true, window = { border = "rounded" } },
      })
      require("max.utils.theme").set_bg({
        "BlinkCmpMenu",
        "BlinkCmpDoc",
        "BlinkCmpDocSeparator",
        "BlinkCmpDocBorder",
        "BlinkCmpMenuBorder",
      })
    end,
  },
}
