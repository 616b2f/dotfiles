vim.lsp.buf.hover({
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})

vim.lsp.buf.signature_help({
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
      },
    },
    -- enable file watch server side, can slow down the server
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
        -- enable file watcher capabilities for lsp clients
        relativePatternSupport = true,
      },
    },
  }
})

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  on_attach = function(client, bufnr)
    -- enable inlay hints if LSP server supports it
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr=bufnr })
    end

    -- Set autocommands conditional on server_capabilities
    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_exec2([[
      augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      {output=true})
    end

    -- enable semantic tokens highligting hints
    if client:supports_method("textDocument/semanticTokens") then
      client.server_capabilities.semanticTokensProvider = true
    end
  end
})

vim.lsp.enable({
  -- 'roslyn_ls',
  'clangd',
  'lua_ls',
  'yamlls',
  'omnisharp',
-- 'pylsp',
-- 'jdtls',
-- 'gdscript',
})
