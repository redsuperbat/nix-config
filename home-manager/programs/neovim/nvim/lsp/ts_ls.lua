---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_dir = function(buf, cb)
    local deno_json_found = vim.fs.root(buf, {
      "deno.json",
    })
    if deno_json_found ~= nil then
      return
    end
    local found = vim.fs.root(buf, {
      "package.json",
      "tsconfig.json",
      ".git",
    })
    if found == nil then
      return
    end
    cb(found)
  end,
  handlers = {
    -- handle rename request for certain code actions like extracting functions / types
    ["_typescript.rename"] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ["end"] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
  on_attach = function(client)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(0, "LspTypescriptSourceAction", function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, "source.")
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        ---@diagnostic disable-next-line: missing-fields
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
  init_options = { hostInfo = "neovim" },
}
