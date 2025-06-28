---@module "overseer"
local float = require("overseer.float")
local name = "lazygit_reflog"
local desc = "Git reflog for current buffer"

--- @param filepath string
local function encode_fish_filepath(filepath)
  local encoded = filepath:gsub("([()%s!#$&'*;<=>?`{|}])", "\\%1")
  return encoded
end

vim.keymap.set("n", "<leader>gr", function()
  require("overseer").run_template({ name = name }, function(task)
    float.enter(task, false)
  end)
end, { desc = desc })

---@type overseer.TemplateDefinition
return {
  name = name,
  builder = function()
    local file = vim.trim(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    file = encode_fish_filepath(file)
    ---@type overseer.TaskDefinition
    return {
      cmd = "lazygit",
      args = { "-f", file },
      cwd = vim.fn.getcwd(),
      components = { "unique", "float.close_on_exit", "default" },
    }
  end,
  desc = desc,
}
