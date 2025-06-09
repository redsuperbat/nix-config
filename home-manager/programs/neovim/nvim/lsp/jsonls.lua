---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_dir = vim.fn.getcwd(),
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "deno.json", "deno.jsonc" },
          url = "https://raw.githubusercontent.com/denoland/deno/refs/heads/main/cli/schemas/config-file.v1.json",
        },
        {
          fileMatch = { "biome.json" },
          url = "https://biomejs.dev/schemas/latest/schema.json",
        },
        {
          fileMatch = { "tsconfig.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = { "package.json" },
          url = "https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/package.json",
        },
        {
          fileMatch = { "postgrestools.jsonc" },
          url = "https://pgtools.dev/schemas/0.0.0/schema.json",
        },
      },
    },
  },
}
