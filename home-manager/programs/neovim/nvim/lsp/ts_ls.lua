local shebang = require("max.utils.shebang")
---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(buf, cb)
    if shebang.is_deno(buf) then
      return
    end
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
  on_attach = function(client, bufnr)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, "source.")
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
          diagnostics = {},
        },
      })
    end, {})

    -- Go to source definition command
    vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptGoToSourceDefinition", function()
      local win = vim.api.nvim_get_current_win()
      local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
      client:exec_cmd({
        command = "_typescript.goToSourceDefinition",
        title = "Go to source definition",
        arguments = { params.textDocument.uri, params.position },
      }, { bufnr = bufnr }, function(err, result)
        if err then
          vim.notify("Go to source definition failed: " .. err.message, vim.log.levels.ERROR)
          return
        end
        if not result or vim.tbl_isempty(result) then
          vim.notify("No source definition found", vim.log.levels.INFO)
          return
        end
        vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
      end)
    end, { desc = "Go to source definition" })
  end,
  init_options = { hostInfo = "neovim" },
}
