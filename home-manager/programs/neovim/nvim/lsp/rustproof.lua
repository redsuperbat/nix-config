---@type vim.lsp.Config
return {
  name = "rustproof",
  cmd = { "rustproof" },
  filetypes = {
    "rust",
    "lua",
    "ruby",
    "javascript",
    "toml",
    "vue",
    "markdown",
    "json",
    "typescript",
    "typescriptreact",
    "text",
    "javascriptreact",
  },
  root_dir = vim.fn.getcwd(),
  init_options = {
    dict_path = "~/.config/nvim/lsp/rustproof-dict.txt",
    diagnostic_severity = "info",
    dictionaries = {
      {
        language = "en",
        aff = "https://raw.githubusercontent.com/wooorm/dictionaries/refs/heads/main/dictionaries/en/index.aff",
        dic = "https://raw.githubusercontent.com/wooorm/dictionaries/refs/heads/main/dictionaries/en/index.dic",
      },
      {
        language = "en_code",
        aff = "https://raw.githubusercontent.com/maxmilton/hunspell-dictionary/refs/heads/master/en_AU.aff",
        dic = "https://raw.githubusercontent.com/maxmilton/hunspell-dictionary/refs/heads/master/en_AU.dic",
      },
      {
        language = "sv",
        aff = "https://raw.githubusercontent.com/wooorm/dictionaries/refs/heads/main/dictionaries/sv/index.aff",
        dic = "https://raw.githubusercontent.com/wooorm/dictionaries/refs/heads/main/dictionaries/sv/index.dic",
      },
    },
  },
}
