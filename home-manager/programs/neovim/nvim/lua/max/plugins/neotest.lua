---@module "lazy"
---@type LazySpec
---@diagnostic disable: missing-fields

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Runners
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-jest",
    "rouge8/neotest-rust",
    "MarkEmmons/neotest-deno",
  },
  event = "VeryLazy",
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rspec"),
        require("neotest-jest"),
        require("neotest-deno"),
        require("neotest-rust")({
          args = { "--no-capture" },
        }),
      },
      discovery = {
        filter_dir = function(name, _, _)
          return name ~= "dist"
        end,
      },
      watch = {
        enabled = false,
      },
    })
    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").run.run()
    end, { desc = "Run test under cursor" })

    vim.keymap.set("n", "<leader>ta", function()
      require("neotest").run.attach()
    end, { desc = "Attach to nearest test" })

    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open({ enter = true })
    end, { desc = "Open nearest test" })

    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run all test in current buffer" })
  end,
}
