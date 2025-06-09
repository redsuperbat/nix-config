local fs = require("max.utils.fs")
---@param data { source: string, destination: string }
local function on_move(data)
  require("snacks").rename.on_rename_file(data.source, data.destination)
end

---@module "lazy"
---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = require("max.utils.fs").root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  config = function()
    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      popup_border_style = "rounded",
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      event_handlers = {
        {
          event = "neo_tree_popup_input_ready",
          ---@param args { bufnr: integer, winid: integer }
          handler = function(args)
            -- map <esc> to enter normal mode (by default closes prompt)
            -- don't forget `opts.buffer` to specify the buffer of the popup.
            vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
          end,
        },
        { event = "file_moved", handler = on_move },
        { event = "file_renamed", handler = on_move },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_hidden = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          -- remains hidden even if visible is toggled to true, this overrides always_show
          never_show = { ".DS_Store", ".git" },
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["S"] = function(state)
            local path = state.tree:get_node().path
            if not fs.is_dir(path) then
              path = vim.fs.dirname(path)
            end
            require("snacks").picker.grep({ cwd = path })
          end,
          ["F"] = function(state)
            local path = state.tree:get_node().path
            if not fs.is_dir(path) then
              path = vim.fs.dirname(path)
            end
            require("snacks").picker.files({ cwd = path })
          end,
          ["Y"] = function(state)
            local path = state.tree:get_node().path
            vim.fn.setreg("+", path, "c")
            vim.print("copied path " .. path)
          end,
          ["O"] = function(state)
            local path = state.tree:get_node().path
            vim.print("opening path " .. path)
            os.execute("open -R " .. path)
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    })

    -- When lazygit floating terminal is closed make sure to update neo-tree git signs
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
