local leader = ","

return {
  "kylechui/nvim-surround",
  version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  ---@module "nvim-surround"
  ---@type user_options
  opts = {
    -- Configuration here, or leave empty to use defaults
    keymaps = {
      insert = "<C-g>s",
      insert_line = "<C-g>S",
      normal = leader,
      normal_cur = leader .. "S",
      normal_line = false,
      normal_cur_line = leader .. "SS",
      visual = leader,
      visual_line = leader .. "S",
      delete = "ds",
      change = "cs",
      change_line = "cS",
    },
  },
}
