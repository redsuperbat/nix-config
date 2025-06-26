local float = require("max.nuggets.overseer_float")

---@param name string
local function open_task_if_exists(name)
  local overseer = require("overseer")

  ---@type overseer.Task|nil
  local task = overseer.list_tasks({ name = name })[1]

  if not task then
    return overseer.run_template({ name = name }, float.enter)
  end

  if not task:is_running() then
    return overseer.run_template({ name = name }, float.enter)
  end

  float.enter(task)
end

local function lazygit_reflog()
  local overseer = require("overseer")
  local name = "lazygit_reflog"
  local desc = "Git reflog for current buffer"

  --- @param filepath string
  local function encode_fish_filepath(filepath)
    local encoded = filepath:gsub("([()%s!#$&'*;<=>?`{|}])", "\\%1")
    return encoded
  end

  vim.keymap.set("n", "<leader>gr", function()
    overseer.run_template({ name = name }, function(task)
      float.enter(task, false)
    end)
  end, { desc = desc })

  ---@type overseer.TemplateDefinition
  local template = {
    name = name,
    builder = function()
      local file = vim.trim(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
      file = encode_fish_filepath(file)
      ---@type overseer.TaskDefinition
      return {
        cmd = "lazygit",
        args = { "-f", file },
        cwd = vim.fn.getcwd(),
        components = { "unique", "float.close_on_exit" },
      }
    end,
    desc = desc,
  }

  overseer.register_template(template)
end

local function lazygit()
  local overseer = require("overseer")
  local name = "lazygit"
  local desc = "Launches lazygit"
  vim.keymap.set("n", "<leader>gg", function()
    open_task_if_exists(name)
  end, { desc = desc })

  ---@type overseer.TemplateDefinition
  local template = {
    name = name,
    builder = function()
      ---@type overseer.TaskDefinition
      return {
        cmd = name,
        cwd = vim.fn.getcwd(),
        components = { "unique", "float.close_on_exit" },
      }
    end,
    desc = desc,
  }

  overseer.register_template(template)
end

local function codex()
  local overseer = require("overseer")
  local name = "codex"
  local desc = "Launches codex"
  local api_key = require("max.utils.fs").read_file("~/.secrets/openai-api-key")
  if not api_key then
    return
  end

  vim.keymap.set("n", "<leader>cc", function()
    overseer.run_template({ name = name }, float.enter)
  end, { desc = desc })

  ---@type overseer.TemplateDefinition
  local template = {
    name = name,
    builder = function()
      ---@type overseer.TaskDefinition
      return {
        cmd = name,
        cwd = vim.fn.getcwd(),
        env = { OPENAI_API_KEY = api_key },
        components = { "float.close_on_exit", "agent.on_input_requested" },
      }
    end,
    desc = desc,
  }
  overseer.register_template(template)
end

---@module "lazy"
---@type LazySpec
return {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
  config = function()
    local overseer = require("overseer")
    overseer.setup({ task_win = { padding = 3 } })
    vim.keymap.set("n", "<leader>oo", overseer.open, {
      desc = "Open overseer",
    })
    lazygit()
    lazygit_reflog()
    codex()
  end,
}
