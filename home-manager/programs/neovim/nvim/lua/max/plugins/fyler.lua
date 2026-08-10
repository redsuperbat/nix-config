--- Absolute path of the item under the cursor
---@param instance table: Fyler finder instance
---@return string|nil
local function cursor_path(instance)
  local node = require("fyler.finder").parse_cursor_line(instance)
  if not node then
    return nil
  end
  return node.link or node.path
end

--- Nearest directory to the item under the cursor
---@param instance table: Fyler finder instance
---@return string|nil
local function cursor_dir(instance)
  local node = require("fyler.finder").parse_cursor_line(instance)
  if not node then
    return nil
  end
  local path = node.link or node.path
  return node.type == "directory" and path or vim.fs.dirname(path)
end

---@return string
local function added_fg()
  for _, group in ipairs({ "String", "GitSignsAdd", "Added" }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if hl.fg then
      return string.format("#%06x", hl.fg)
    end
  end
  return "#98BB6C"
end

---@module "lazy"
---@type LazySpec
return {
  "FylerOrg/fyler.nvim",
  dependencies = { "nvim-web-devicons" },
  keys = {
    {
      "<leader>e",
      function()
        require("fyler").toggle({ kind = "split_left_most", root_path = require("max.utils.fs").root() })
      end,
      desc = "File-tree explorer",
    },
    {
      "<leader>E",
      function()
        require("fyler").toggle({ kind = "split_left_most", root_path = vim.fn.getcwd() })
      end,
      desc = "File-tree explorer (cwd)",
    },
  },
  opts = {
    integrations = {
      icon = "nvim_web_devicons",
    },
    extensions = {
      git = {
        enabled = true,
        icons = {
          -- Upstream has no entry for added files, so a `git add`ed file
          -- would otherwise render with no marker at all.
          ["A "] = { icon = "+", hl = "FylerGitStaged" },
          ["AM"] = { icon = "+", hl = "FylerGitStaged" },
        },
      },
      watcher = { enabled = true },
    },
    hooks = {
      on_rename = function(src_path, destination_path)
        require("snacks").rename.on_rename_file(src_path, destination_path)
      end,
      -- Also runs on ColorScheme, so the tint survives a theme switch.
      on_highlight = function()
        vim.api.nvim_set_hl(0, "FylerGitUntracked", { fg = added_fg(), bold = true })
      end,
    },
    mappings = {
      n = {
        ["S"] = {
          action = function(instance)
            local path = cursor_dir(instance)
            if not path then
              return
            end
            require("snacks").picker.grep({ cwd = path })
          end,
        },
        ["F"] = {
          action = function(instance)
            local path = cursor_dir(instance)
            if not path then
              return
            end
            require("snacks").picker.files({ cwd = path })
          end,
        },
        ["Y"] = {
          action = function(instance)
            local path = cursor_path(instance)
            if not path then
              return
            end
            vim.fn.setreg("+", path, "c")
            vim.print("copied!")
          end,
        },
        ["O"] = {
          action = function(instance)
            local path = cursor_path(instance)
            if not path then
              return
            end
            os.execute("open -R " .. vim.fn.shellescape(path))
          end,
        },
      },
    },
  },
}
