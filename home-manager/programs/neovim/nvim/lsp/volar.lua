---@type vim.lsp.Config
return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = {
    "vue",
  },
  root_markers = {
    "deno.json",
  },
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
    },
  },
}
