---@module "lazy"
---@type LazySpec
return {
  "joryeugene/dadbod-grip.nvim",
  version = "*",
  keys = {
    {
      "<leader>dd",
      function()
        local db_url = vim.env.DATABASE_URL

        if db_url == nil then
          vim.print("No database url configured")
          return
        end

        vim.cmd("GripOpen " .. db_url)
      end,
      desc = "Open dadbod grip",
    },
  },
  config = function()
    require("dadbod-grip").setup({
      keymaps = {
        ai = "<leader>da",
        table_picker = "<leader><space>",
        grid_edit = "c",
        grid_apply = "w",
        grid_delete = "dd",
        grid_col_next = "l",
        grid_col_prev = "h",
        grid_clone = "gmm",
      },
    })
  end,
}
