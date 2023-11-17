local lspconfig = require('lspconfig')
-- local lspconfig_util = require('lspconfig.util')
require("mason-lspconfig").setup()

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single"
  }
)

-- local util = require('lspconfig/util')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lsp_signature = require('lsp_signature')

local on_attach = function(client, bufnr)
  lsp_signature.on_attach({})

  -- enable inlay hints if LSP server supports it
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint(bufnr, true)
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
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- capabilities.textDocument.semanticTokens = true
  -- capabilities.workspace.semanticTokens = true
  -- capabilities.textDocument.documentFormattingProvider
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

-- Register a handler that will be called for all installed servers.
 require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function (server_name) -- default handler (optional)
    local config = make_config()
    lspconfig[server_name].setup(config)
  end,

  -- Next, you can provide a dedicated handler for specific servers.
  -- ["jdtls"] = function ()
  --   local mason_registry = require("mason-registry")
  --   local jdtls = mason_registry.get_package("jdtls") -- note that this will error if you provide a non-existent package name
  --   local config = make_config()
  --
  --   local env = {
  --     HOME = vim.loop.os_homedir(),
  --     XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  --     JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
  --   }
  --
  --   local function get_cache_dir()
  --     return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or lspconfig_util.path.join(env.HOME, '.cache')
  --   end
  --
  --   local function get_jdtls_cache_dir()
  --     return lspconfig_util.path.join(get_cache_dir(), 'jdtls')
  --   end
  --
  --   local function get_jdtls_config_dir()
  --     return lspconfig_util.path.join(get_jdtls_cache_dir(), 'config')
  --   end
  --
  --   local function get_jdtls_workspace_dir()
  --     return lspconfig_util.path.join(get_jdtls_cache_dir(), 'workspace')
  --   end
  --
  --   local function get_jdtls_jvm_args()
  --     local args = {}
  --     for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
  --       local arg = string.format('--jvm-arg=%s', a)
  --       table.insert(args, arg)
  --     end
  --     return unpack(args)
  --   end
  --
  --   config.cmd = {
  --     'java',
  --     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  --     '-Dosgi.bundles.defaultStartLevel=4',
  --     '-Declipse.product=org.eclipse.jdt.ls.core.product',
  --     '-Dlog.protocol=true',
  --     '-Dlog.level=ALL',
  --     '-Xmx1g',
  --     '--add-modules=ALL-SYSTEM',
  --     '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  --     '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  --     -- 💀
  --     '-jar', jdtls:get_install_path() .. "/plugins/org.eclipse.equinox.launcher_*.jar",
  --     '-configuration', get_jdtls_config_dir(),
  --     -- See `data directory configuration` section in the README
  --     '-data', get_jdtls_workspace_dir()
  --   }
  --   config.root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
  --   -- Here you can configure eclipse.jdt.ls specific settings
  --   -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  --   -- for a list of options
  --   config.settings = {
  --     java = {}
  --   }
  --
  --   -- Language server `initializationOptions`
  --   -- You need to extend the `bundles` with paths to jar files
  --   -- if you want to use additional eclipse.jdt.ls plugins.
  --   --
  --   -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --   --
  --   -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  --   config.init_options = {
  --     bundles = {}
  --   }
  --
  --   -- special case here because we use nvim-jdtls
  --   require('jdtls').start_or_attach(config)
  -- end,

  ["lua_ls"] = function ()
    local config = make_config()
    config.settings = {
      Lua = {
        workspace = {
          checkThirdParty = false, -- stop asking for config env as openresty
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      }
    }
    lspconfig.lua_ls.setup(config)
  end,

  ["pylsp"] = function ()
    local config = make_config()
    config.settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            -- ignore = {'W391'},
            maxLineLength = 100
          }
        }
      }
    }
    lspconfig.pylsp.setup(config)
  end,

  ["omnisharp"] = function ()
    local config = make_config()
    config.handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    }
    lspconfig.omnisharp.setup(config)
  end,

  ["yamlls"] = function ()
    local config = make_config()
    config.settings = {
      yaml = {
        completion = true,
        hover = true,
        validate = true,
        schemas = {
          ['http://json.schemastore.org/github-workflow'] = {
            '.github/workflows/*.{yml,yaml}',
          },
          ["http://json.schemastore.org/kustomization"] = {
            "kustomization.yaml",
          },
          ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v4beta6.json"] = {
            "skaffold.yaml",
          },
          kubernetes = "*.yaml",
          -- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.26.9-standalone-strict/all.json"] = {
          --   "*.yaml",
          -- },
        },
        format = {
          enable = true
        },
        schemaStore = {
          url = "https://www.schemastore.org/api/json/catalog.json",
          enable = true
        }
      },
      http = {
        proxyStrictSSL = true
      }
    }
    lspconfig.yamlls.setup(config)
  end
}

