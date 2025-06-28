local float = require("overseer.float")
local active_agents = require("overseer.active_agents")
---@module "lazy"
---@module "overseer"
---@module "snacks"

local cli_agents = {
  "codex",
  "gemini",
  "claude",
}

local agent = cli_agents[1]

---@type LazySpec
return {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
  config = function()
    local overseer = require("overseer")
    overseer.setup({
      task_win = { padding = 3 },
      templates = vim.tbl_map(function(a)
        return "agents." .. a
      end, cli_agents),
    })

    overseer.register_template(require("overseer.template.lazygit.default"))
    overseer.register_template(require("overseer.template.lazygit.reflog"))

    vim.keymap.set("n", "<leader>co", function()
      ---@type overseer.Task[]
      local tasks = overseer.list_tasks()

      local items = {} ---@type snacks.picker.finder.Item[]
      for _, task in ipairs(tasks) do
        local text = task.name
        ---@type snacks.picker.finder.Item
        local item = {
          data = { task = task },
          text = text,
        }
        if task.metadata.is_agent ~= nil then
          table.insert(items, item)
        end
      end

      if #tasks == 0 then
        vim.print("No tasks running")
        return
      end

      require("snacks").picker.pick({
        source = "ai_agents",
        items = items,
        format = "text",
        layout = {
          preset = "vscode",
          layout = { width = 0.4, border = "rounded" },
        },
        confirm = function(picker, item)
          picker:close()
          ---@type overseer.Task|nil
          local task = item.data.task
          if not task then
            return
          end
          float.enter(task)
        end,
      })
    end, {
      desc = "Open AI Agents",
    })

    vim.keymap.set("n", "<leader>cp", function()
      active_agents.pop_enter()
    end, {
      desc = "Jump to the latest agent waiting for input",
    })

    vim.keymap.set("n", "<leader>cf", function()
      require("snacks").picker.pick({
        source = "ai_agents",
        title = "Current agent cli: " .. agent,
        items = vim.tbl_map(
          ---@param a string
          function(a)
            ---@type snacks.picker.finder.Item
            return {
              text = a,
              data = { agent = a },
            }
          end,
          vim.tbl_filter(
            ---@param a string
            function(a)
              return a ~= agent
            end,
            cli_agents
          )
        ),
        confirm = function(picker, item)
          picker:close()
          agent = item.data.agent
        end,
        format = "text",
        layout = {
          preset = "vscode",
          layout = { width = 0.4, border = "rounded" },
        },
      })
    end, { desc = "Choose supported agent CLI" })

    vim.keymap.set("n", "<leader>cc", function()
      overseer.run_template({ name = agent })
    end, { desc = "Open a new agent with an initial prompt" })
  end,
}
