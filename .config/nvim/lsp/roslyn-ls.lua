local function on_attach(client, bufnr)
  -- enable inlay hints if LSP server supports it
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr=bufnr })
  end

  -- Set autocommands conditional on server_capabilities
  if client.supports_method("textDocument/documentHighlight") then
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
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = true
  end
end

-- config that activates keymaps and enables snippet support
local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
  -- enable file watcher capabilities for lsp clients
  capabilities.workspace.didChangeWatchedFiles.relativePatternSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

  --- HACKs source: https://github.com/seblj/roslyn.nvim
  -- HACK: Enable filewatching to later just not watch any files
  -- This is to not make the server watch files and make everything super slow in certain situations
  -- capabilities = vim.tbl_deep_extend("force", capabilities, {
  --     workspace = {
  --         didChangeWatchedFiles = {
  --             dynamicRegistration = true,
  --         },
  --     },
  -- })

  -- -- HACK: Doesn't show any diagnostics if we do not set this to true
  -- capabilities = vim.tbl_deep_extend("force", capabilities, {
  --     textDocument = {
  --         diagnostic = {
  --             dynamicRegistration = true,
  --         },
  --     },
  -- })
  --
  return capabilities
end


local function start_roslyn_server(pipe_name)
    vim.system({
      "./Microsoft.CodeAnalysis.LanguageServer",
      -- "dotnet",
      -- "Microsoft.CodeAnalysis.LanguageServer.dll",
      "--logLevel",
      "Trace",
      "--extensionLogDirectory",
      "/var/home/ak/devel/roslyn/logs/",
      "--pipe",
      pipe_name
    },
    { cwd = "/var/home/ak/devel/roslyn/artifacts/LanguageServer/Release/net8.0/linux-x64/" })
    vim.uv.sleep(1500)
end

local function roslyn_config()
  ---@type vim.lsp.ClientConfig
  local config = {
    name = "roslynlsp",
    offset_encoding = 'utf-8',
    ---@param dispatchers vim.lsp.rpc.Dispatchers
    cmd = function (dispatchers)
      local pipe_name = "/tmp/422df9c8340645ba8966061884b388aa.sock"
      start_roslyn_server(pipe_name)
      return vim.lsp.rpc.connect(pipe_name)(dispatchers)
    end,
    filetypes = { "cs" },
    -- get_language_id = function (_, filetype)
    --   if filetype == "cs" then
    --     return "csharp"
    --   end
    --   return ""
    -- end,
    root_dir = vim.fs.root(0, function (name, _)
      return name:match("%.sln") ~= nil or name:match("%.csproj$") ~= nil
    end),
    capabilities = create_capabilities(),
    on_attach = on_attach,
    settings = {
      ["csharp|background_analysis"] = {
        dotnet_analyzer_diagnostics_scope = "fullSolution",
        dotnet_compiler_diagnostics_scope = "fullSolution"
      },
      ["csharp|inlay_hints"] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
        csharp_enable_inlay_hints_for_types = true,
        dotnet_enable_inlay_hints_for_indexer_parameters = true,
        dotnet_enable_inlay_hints_for_literal_parameters = true,
        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
        dotnet_enable_inlay_hints_for_other_parameters = true,
        dotnet_enable_inlay_hints_for_parameters = true,
        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
      },
      ["csharp|symbol_search"] = {
        dotnet_search_reference_assemblies = true
      },
      ["csharp|completion"] = {
        dotnet_show_name_completion_suggestions = true,
        dotnet_show_completion_items_from_unimported_namespaces = true,
        dotnet_provide_regex_completions = true,
      },
      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = true,
      },
    }
  }
  return config
end

vim.lsp.config("roslyn-ls", roslyn_config())

