local lspconfig = require('lspconfig')
require("mason-lspconfig").setup()

-- local util = require('lspconfig/util')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lsp_signature = require('lsp_signature')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    lsp_signature.on_attach({})

    -- disable semantic tokens till omnisharp fixes the issue
    client.server_capabilities.semanticTokensProvider = nil

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
    buf_set_keymap('n', '<space>qe', '<cmd>lua vim.diagnostic.setqflist({severity=vim.diagnostic.severity.ERROR})<CR>', opts)
    buf_set_keymap('n', '<space>ql', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
    end

    -- config that activates keymaps and enables snippet support
    local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
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
        ["sumneko_lua"] = function ()
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
            lspconfig.sumneko_lua.setup(config)
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
                        -- ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
                        -- Kubernetes= "/*.yaml",
                        -- "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json": [ "/*.k8s.yaml" ],
                        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.0/deployment-apps-v1.json"] = "/*.yaml",
                        ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
                        ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta26.json"] = "skaffold.yaml"
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

