---@module "lazy"
---@type LazySpec
return {
  "echasnovski/mini.bufremove",
  keys = {
    {
      "<leader>bd",
      function()
        local delete = require("mini.bufremove").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            delete(0)
          elseif choice == 2 then -- No
            delete(0, true)
          end
        else
          delete(0)
        end
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bD",
      function()
        require("mini.bufremove").delete(0, true)
      end,
      desc = "Delete Buffer (Force)",
    },
  },
}
