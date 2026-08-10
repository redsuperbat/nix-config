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

local function register_gitignore_extension()
  local refreshes = 0

  require("fyler.extensions").register({
    name = "gitignore",
    setup = function(opts, config)
      config.extensions.gitignore = vim.tbl_deep_extend("force", { enabled = true }, opts)
    end,
    hooks = {
      finder_refresh_post = function(instance, visible, hl_ns, lines)
        if not require("fyler.config").DATA.extensions.gitignore.enabled then
          return
        end

        local paths = {}
        for _, item in ipairs(visible) do
          paths[#paths + 1] = item.path
        end
        if #paths == 0 then
          return
        end

        refreshes = refreshes + 1
        local token = refreshes
        vim.system(
          { "git", "-C", instance.state.pseudo_root_path, "check-ignore", "-z", "--stdin" },
          { stdin = table.concat(paths, "\0") .. "\0", text = true },
          function(result)
            -- 1 means nothing was ignored, 128 means not a repository
            if result.code ~= 0 or token ~= refreshes then
              return
            end

            local ignored = {}
            for _, path in ipairs(vim.split(result.stdout, "\0", { plain = true, trimempty = true })) do
              ignored[path] = true
            end

            vim.schedule(function()
              for i, item in ipairs(visible) do
                if ignored[item.path] then
                  pcall(vim.api.nvim_buf_set_extmark, instance.buf_id, hl_ns, i - 1, 0, {
                    hl_group = "FylerGitIgnored",
                    end_line = i - 1,
                    end_col = #(lines[i] or ""),
                    hl_mode = "combine",
                    priority = 5000,
                  })
                end
              end
            end)
          end
        )
      end,
    },
  })
end

local function refresh_on_write()
  local pending = false

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("MaxFylerGitRefresh", { clear = true }),
    desc = "Force a Fyler git status refresh after a write",
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" or pending then
        return
      end

      pending = true
      vim.defer_fn(function()
        pending = false
        local instance = require("fyler.finder").instance_get_or_nil()
        if not instance then
          return
        end
        pcall(function()
          instance:refresh({ force = true, recursive = true })
        end)
      end, 300)
    end,
  })
end

---@module "lazy"
---@type LazySpec
return {
  "FylerOrg/fyler.nvim",
  dependencies = { "nvim-web-devicons" },
  config = function(_, opts)
    -- Registered before setup so it is found when its opts are read
    register_gitignore_extension()
    require("fyler").setup(opts)
    refresh_on_write()
  end,
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
      gitignore = { enabled = true },
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
