local float = require("overseer.float")
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
      task_win = { padding = 3 },
      templates = {
        "agents.codex",
        "agents.gemini",
        "agents.claude",
      },
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
        if task.metadata.initial_prompt ~= nil then
          table.insert(items, item)
        end
      end

      if #tasks == 0 then
        vim.print("No tasks running")
        return
      end

      Snacks.picker.pick({
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

    vim.keymap.set("n", "<leader>cc", function()
      overseer.run_template({ name = "codex" })
    end, { desc = "Open a new agent with an initial prompt" })
  end,
}
