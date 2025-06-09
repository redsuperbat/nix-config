local fs = require("max.utils.fs")
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not fs.path_exists(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazy_path)

require("lazy").setup({
  ui = {
    backdrop = 100,
    border = "rounded",
    size = { width = 0.85, height = 0.85 },
    custom_keys = {
      ["K"] = false,
    },
  },
  rocks = {
    enabled = false,
  },
  spec = {
    { import = "max.plugins" },
    { import = "max.plugins.snacks" },
  },
  defaults = {
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
  },
  checker = { enabled = true, notify = false }, -- automatically check for plugin updates
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
