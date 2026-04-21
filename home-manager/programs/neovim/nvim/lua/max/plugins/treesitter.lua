---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    keys = {
      {
        "<C-space>",
        function()
          local select = require("vim.treesitter._select")
          if vim.fn.mode() == "n" then
            vim.cmd("normal! v")
          end
          select.select_parent(vim.v.count1)
        end,
        desc = "Increment Selection",
        mode = { "n", "x" },
      },
      {
        "<bs>",
        function()
          require("vim.treesitter._select").select_child(vim.v.count1)
        end,
        desc = "Decrement Selection",
        mode = "x",
      },
    },
    config = function()
      local parsers =
        { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then
            return
          end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- use smartindent instead of treesitter indentation
          -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "lewis6991/ts-install.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      local ensure_installed = {
        "bash",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "typescript",
        "nix",
        "javascript",
        "vue",
      }
      require("ts-install").setup({
        ensure_install = ensure_installed,
        auto_install = true,
      })
    end,
  },
}
