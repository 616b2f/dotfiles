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
      vim.lsp.semantic_tokens.enable(true, {client_id=client.id})
    end
  end
})

vim.lsp.config("omnisharp", {
 cmd = {
    "/var/home/ak/devel/omnisharp-roslyn/bin/Release/OmniSharp.Stdio.Driver/net8.0/OmniSharp",
    '-z', -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
    '--hostPID',
    tostring(vim.fn.getpid()),
    'DotNet:enablePackageRestore=false',
    '--encoding',
    'utf-8',
    '--languageserver',
  },
})

vim.lsp.enable({
  -- 'roslyn_ls',
  'clangd',
  'lua_ls',
  'yamlls',
  'omnisharp',
  'gh_actions_ls',
-- 'pylsp',
-- 'jdtls',
-- 'gdscript',
})
