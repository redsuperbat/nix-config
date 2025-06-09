---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "eruby",
    "html",
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    "stylus",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "package.json",
  },
  init_options = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
      },
    },
  },
}
