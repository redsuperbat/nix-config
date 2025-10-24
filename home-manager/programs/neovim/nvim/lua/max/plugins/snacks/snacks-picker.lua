local tsc_picker = {
  finder = function()
    local cmd = { "npx", "tsgo", "--noEmit", "--pretty", "false" }
    local output = vim.fn.system(cmd)
    local items = {}

    -- Parse tsc output (format: file.ts(line,col): error TS1234: message)
    for line in output:gmatch("[^\n]+") do
      local file, lnum, col, code, msg = line:match("(.+)%((%d+),(%d+)%): error (TS%d+): (.+)")

      if file then
        table.insert(items, {
          file = file,
          pos = { tonumber(lnum), tonumber(col) - 1 },
          text = file .. " " .. msg .. " " .. code,
          item = {
            message = msg,
            code = code,
            source = "TypeScript",
            severity = vim.diagnostic.severity.ERROR,
          },
          severity = vim.diagnostic.severity.ERROR,
        })
      end
    end
    return items
  end,

  format = "diagnostic",
  preview = "file",
  actions = {
    default = "edit",
  },
  layout = {
    fullscreen = true,
  },
}

---
---@module "lazy"
---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          layout = {
            fullscreen = true,
          },
        },
        recent = {
          hidden = true,
          layout = {
            fullscreen = true,
          },
        },
        git_status = {
          layout = {
            fullscreen = true,
          },
        },
        grep = {
          hidden = true,
          layout = {
            fullscreen = true,
          },
        },
        lsp_references = {
          layout = { fullscreen = true },
        },
      },
      formatters = { file = { truncate = 120 } },
      layout = { preset = "telescope" },
    },
  },
  init = function()
    require("max.utils.theme").set_bg({
      "SnacksPickerFile",
      "SnacksPickerList",
      "SnacksPickerInput",
      "SnacksPickerInputSearch",
      "SnacksPickerBorder",
      "SnacksPickerBoxBorder",
      "SnacksPickerListBorder",
      "SnacksPickerInputBorder",
      "SnacksPickerPreview",
      "SnacksPickerPreviewBorder",
      "SnacksPickerPreviewFooter",
      "SnacksPickerPreviewTitle",
    })
  end,
  keys = {
    {
      "<leader>fb",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>sG",
      function()
        require("snacks").picker.grep({ cwd = require("max.utils.fs").root() })
      end,
      desc = "Grep",
    },
    {
      "<leader>:",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader><space>",
      function()
        require("snacks").picker.files({ cwd = require("max.utils.fs").root() })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fc",
      function()
        require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>ff",
      function()
        require("snacks").picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("snacks").picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent",
    },
    -- git
    {
      "<leader>gc",
      function()
        require("snacks").picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gs",
      function()
        require("snacks").picker.git_status()
      end,
      desc = "Git Status",
    },
    -- Grep
    {
      "<leader>sb",
      function()
        require("snacks").picker.lines({
          matcher = {
            regex = true,
          },
        })
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sB",
      function()
        require("snacks").picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>sg",
      function()
        require("snacks").picker.grep({})
      end,
      desc = "Grep",
    },
    {
      "<leader>sv",
      function()
        local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
        require("snacks").picker.grep({ search = vim.fn.join(lines, " ") })
      end,
      desc = "Search text marked by visual",
      mode = "v",
    },
    {
      "<leader>sl",
      function()
        local line = vim.fn.getline(".")
        require("snacks").picker.grep({ search = line })
      end,
      desc = "Search text in current line",
      mode = "n",
    },
    {
      "<leader>sw",
      function()
        require("snacks").picker.grep({
          search = vim.fn.expand("<cword>"),
        })
      end,
      desc = "Search word under cursor",
      mode = "n",
    },
    -- search
    {
      '<leader>s"',
      function()
        require("snacks").picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>sa",
      function()
        require("snacks").picker.autocmds()
      end,
      desc = "Autocmds",
    },
    {
      "<leader>sc",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        require("snacks").picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sD",
      function()
        require("snacks").picker(tsc_picker)
      end,
      desc = "All tsc diagnostics",
    },
    {
      "<leader>sd",
      function()
        require("snacks").picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sh",
      function()
        require("snacks").picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sH",
      function()
        require("snacks").picker.highlights()
      end,
      desc = "Highlights",
    },
    {
      "<leader>sj",
      function()
        require("snacks").picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        require("snacks").picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sM",
      function()
        require("snacks").picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>sm",
      function()
        require("snacks").picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>sR",
      function()
        require("snacks").picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>sq",
      function()
        require("snacks").picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>uC",
      function()
        require("snacks").picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>pp",
      function()
        require("snacks").picker.projects()
      end,
      desc = "Projects",
    },
    -- LSP
    {
      "gd",
      function()
        require("snacks").picker.lsp_definitions({
          on_show = function(picker)
            vim.schedule(function()
              if picker:count() > 0 then
                picker:action("confirm")
              end
            end)
          end,
        })
      end,
      desc = "Goto Definition",
    },
    {
      "gr",
      function()
        require("snacks").picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gi",
      function()
        require("snacks").picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        require("snacks").picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "<leader>ss",
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
  },
}
