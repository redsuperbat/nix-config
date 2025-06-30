local fs = require("max.utils.fs")
local float = require("overseer.float")
local active_agents = require("overseer.active_agents")

local cli_agents = {
  "codex",
  "gemini",
  "claude",
}

local agent_path = vim.fn.stdpath("cache") .. "/rsb_ai_agents"
local maybe_agent = fs.read_file(agent_path)
local agent = maybe_agent or cli_agents[1]

---@module "lazy"
---@module "overseer"
---@module "snacks"
---@type LazySpec
return {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
  config = function()
    local overseer = require("overseer")
    overseer.setup({
      task_win = { padding = 3, border = "none" },
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
        local buf_nr = task:get_bufnr()

        ---@type snacks.picker.finder.Item
        local item = {
          data = { task = task },
          text = text,
        }
        if buf_nr then
          item.file = vim.api.nvim_buf_get_name(buf_nr)
        end
        if task.metadata.is_agent ~= nil then
          table.insert(items, item)
        end
      end

      require("snacks").picker.pick({
        source = "ai_agents",
        items = items,
        format = "text",
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

    vim.keymap.set("n", "<leader>cn", function()
      active_agents.pop_enter()
    end, {
      desc = "Jump to the latest agent waiting for input",
    })

    vim.keymap.set("n", "<leader>cp", function()
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
          fs.write_file(agent_path, agent)
        end,
        format = "text",
        layout = { preset = "vscode", layout = { width = 0.4, height = 0.1 } },
      })
    end, { desc = "Choose supported agent CLI" })

    vim.keymap.set("n", "<leader>cc", function()
      overseer.run_template({ name = agent })
    end, { desc = "Open a new agent with an initial prompt" })
  end,
}
