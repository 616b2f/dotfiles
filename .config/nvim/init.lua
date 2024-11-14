-- enable experimental loader
vim.loader.enable()

-- Install LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- UI to select things (files, grep results, open buffers...)
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-ui-select.nvim',
    config = function ()
      require("telescope").load_extension("ui-select")
    end
  },

  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Add git related info in the signs columns and popups
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  -- git plugin
  {
    'NeogitOrg/neogit',
    branch = "master",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim'
    }
  },
  --'tpope/vim-fugitive', -- Git commands in nvim
  --'tpope/vim-rhubarb', -- Fugitive-companion to interact with github

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter

  -- nvim lsp support
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "file:~/devel/mason-registry"
        -- "github:616b2f/mason-registry@main"
        -- "file:~/devel/mason-registry"
      }
    }
  },
  "williamboman/mason-lspconfig.nvim", -- for better integration with lspconfig
  "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- for easier installing tools
  {
    'j-hui/fidget.nvim',
    branch = "main",
    opts = {
      notification = {
        override_vim_notify = false,
        view = {
          stack_upwards = false
        },
        window = {
          align = "top"
        }
      },
    } -- `opts = {}` is the same as calling `require('fidget').setup({})`
  }, -- Useful status updates for LSP

  -- specific for csharp allows goto definition for decompiled binaries
  "Hoffs/omnisharp-extended-lsp.nvim",

  "mfussenegger/nvim-jdtls", -- specific for java, add some special config

  -- Additional lua configuration, makes nvim stuff amazing
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        'bsp.nvim',
        'neotest',
        -- Load luvit types when the `vim.uv` word is found
        -- { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  -- complete support
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = 'default' },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',

      -- experimental auto-brackets support
      accept = { auto_brackets = { enabled = true } },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },
      kind_icons = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',

        Field = '',
        Variable = '',
        Property = '',

        Class = '',
        Interface = '',
        Struct = '',
        Module = '󰅩',

        Unit = '',
        Value = '',
        Enum = '',
        EnumMember = '',

        Keyword = '',
        Constant = '',

        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
      },
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" }
  },
  'onsails/lspkind-nvim',
  'tjdevries/complextras.nvim',
  -- 'saadparwaiz1/cmp_luasnip',
  -- 'L3MON4D3/LuaSnip', -- Snippets plugin
  -- 'rafamadriz/friendly-snippets', -- basic snippets

  -- custom formatters
  'mhartington/formatter.nvim',

  -- color schemes
  -- 'gbprod/nord.nvim',

  -- colorscheme helper
  'tjdevries/colorbuddy.nvim',

  -- colorizer (show colors for RGB and there like)
  'norcalli/nvim-colorizer.lua',

  -- comment plugins
  -- {
  --   'numtostr/comment.nvim', -- "gc" to comment visual regions/lines
  --   opt = {}
  -- },
  --'tomtom/tcomment_vim',
  --'preservim/nerdcommenter',

  -- Plugin outside ~/.vim/plugged with post-update hook
  --'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' },
  --'junegunn/fzf.vim',

  -- lightline plugin for pretty statusline
  {
    'nvim-lualine/lualine.nvim', -- Fancier statusline
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true } -- for file icons
  },
  -- 'itchyny/lightline.vim',

  -- essential plugins,
  -- 'tpope/vim-surround',
  { 'echasnovski/mini.nvim', branch = 'stable' },

  -- debugger adapter protocoll support
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',

  -- unit test plugins
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  },
  {
    "Issafalcon/neotest-dotnet",
    dependencies = {
      {
        "nvim-neotest/neotest",
      },
    }
  },

  -- file explorer like NERDtree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icon
    }
  },
  {
    'gnikdroy/projections.nvim',
    branch = "pre_release",
    config = function()
      require("projections").setup({
        workspaces = {                        -- Default workspaces to search for 
          { "~/devel/ext", { ".git" } },      -- devel/ext is a workspace. patterns = { ".git" }
          { "~/devel", { ".git" } },          -- devel is a workspace. patterns = { ".git" }
          { "~/devel/projects", { ".git" } },      -- devel/projects is a workspace. patterns = { ".git" }
        },
        store_hooks = {
          pre = function()
            -- some workaround to not save tab state of some plugins,
            -- restoring the session with those tabs open results in an bad UX

            -- close nvim tree tab if open
            local nvim_tree_present, nvim_tree_api = pcall(require, "nvim-tree.api")
            if nvim_tree_present then nvim_tree_api.tree.close() end

            -- close neogit status tab if open
            local neogit_present, neogit_api = pcall(require, "neogit")
            if neogit_present and neogit_api.status.status_buffer then
              neogit_api.status.close()
            end
          end
        }
      })

      -- configure projection to also switch cwd in nvim-tree
      -- when project is switched
      local switcher = require("projections.switcher")
      local nvim_tree_present, api = pcall(require, "nvim-tree.api")
      if nvim_tree_present then
        local original_switch_function = switcher.switch
        switcher.switch = function(spath)
          -- pre hooks here
          local result = original_switch_function(spath)
          -- unconditional post hooks here
          if result then
            --- post hook that only runs if project switching was successful
            api.tree.change_root(spath)

            local lualine_present, lualine_api = pcall(require, "lualine")
            if lualine_present then
              lualine_api.refresh()
            end
          end
          return result
        end
      end

      require('telescope').load_extension('projections')
    end
  },

  {
    'smoka7/hop.nvim',
    version = '*',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup()
    end
  },
  -- "nvim-telescope/telescope-file-browser.nvim"

  -- terraform plugin
  'hashivim/vim-terraform',

  -- nice helper for registers
  {
    'tversteeg/registers.nvim',
    config = function ()
      require("registers").setup()
    end,
  },

  -- plugin to show function signatures in a better way
  -- {
  --   'ray-x/lsp_signature.nvim',
  --   event = "VeryLazy",
  --   opts = {},
  --   config = function(_, opts) require'lsp_signature'.setup(opts) end
  -- },

  -- vscode like task runner
  {
    'stevearc/overseer.nvim',
    opts = {},
  },

  {
    -- '616b2f/bsp.nvim'
    dir = "~/devel/bsp.nvim"
  },

  -- Useful status updates for LSP
  {
    'j-hui/fidget.nvim',
    branch = "main",
    opts = {
      notification = {
        override_vim_notify = true
      }
    }, -- `opts = {}` is the same as calling `require('fidget').setup({})` branch = "main"
  },

  -- show markdown in a nicer way
  {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {},
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons'
      },
  }
})

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
-- if is_bootstrap then
--   print '=================================='
--   print '    Plugins are being installed'
--   print '    Wait until Packer completes,'
--   print '       then restart nvim'
--   print '=================================='
--   return
-- end

-- enable filetype.lua and disable filetype.vim
vim.g.do_filetype_lua = 1

vim.o.title = true
vim.o.titlestring = "nvim: %t"

-- dont fix end of line in files
vim.o.fixendofline = false

-- sync default registers with clipboard
vim.o.clipboard="unnamedplus"

-- set default tab to spaces
-- length of an actual \t character:
vim.o.tabstop=4
-- length to use when editing text (eg. TAB and BS keys)
-- (0 for ‘tabstop’, -1 for ‘shiftwidth’):
vim.o.softtabstop=-1
-- length to use when shifting text (eg. <<, >> and == commands)
-- (0 for ‘tabstop’):
vim.o.shiftwidth=0
-- round indentation to multiples of 'shiftwidth' when shifting text
-- (so that it behaves like Ctrl-D / Ctrl-T):
vim.o.shiftround=true

vim.o.scrolloff = 8

-- if set, only insert spaces; otherwise insert \t and complete with spaces:
vim.o.expandtab=true

-- show special characters like tabs and trailing spaces
vim.opt.listchars = {
  tab = '> ',
  eol = '⤶',
  nbsp = '✚',
  trail = '-',
  extends = '◀',
  precedes = '▶',
}
vim.o.list = true

-- reproduce the indentation of the previous line:
vim.o.autoindent = true
-- indent after { and so on
vim.o.smartindent = true

-- diff customizations
vim.o.fillchars='diff:╱'

-- activate word diff and char diff
--vim.o.diffopt = { worddiff = '100', chardiff= '100' }
--vim.o.diffopt = 'worddiff:100,chardiff:100'
vim.cmd [[
  " set diffopt+=worddiff:100
  set diffopt+=linematch:100
]]

-- fix indentation for file types
vim.cmd [[
    autocmd FileType lua setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType javascript setlocal ts=4 sts=4 sw=0 expandtab
    autocmd FileType groovy setlocal ts=4 sts=4 sw=0 expandtab
    autocmd FileType go setlocal ts=4 sts=4 sw=4 noexpandtab

    " set coloring for vifmrc
    autocmd BufNewFile,BufRead vifmrc set syntax=vim

    " this is needed for LSP terraform server to work
    autocmd BufNewFile,BufRead *.tf,*.tfvars set filetype=terraform

    " set intendation for *.csproj files
    autocmd FileType cs setlocal commentstring=//\ %s
    autocmd BufNewFile,BufRead *.csproj setlocal ts=2 sts=2 sw=2 expandtab
    autocmd BufNewFile,BufRead *.props set syntax=xml ft=xml
]]

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- show max width column, to gide you howlong the line should be
-- vim.o.colorcolumn = "80"

-- Set colorscheme
vim.o.termguicolors = true
--require("nord").setup({
--  diff = { mode = "fg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
--})
-- vim.cmd[[colorscheme nord]]
-- set bg color of floating windows to a different color than normal background
-- vim.api.nvim_set_hl(0, 'NormalFloat', { fg='#d8dee9', bg='#3b4252'})

vim.o.hidden=true

-- Some servers have issues with backup files, see #649.
vim.o.backup=false
vim.o.writebackup=false

-- Give more space for displaying messages.
vim.o.cmdheight=2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.o.updatetime=300

require'nvim-tree'.setup {
  update_cwd = false,
  update_focused_file = {
    update_cwd = false
  },
  view = {
    width = 70
  },
  renderer = {
    highlight_git = true, -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
    add_trailing = true,
    icons = {
      show = {
        git = false,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = { -- default shows no icon by default
        git = {
          unstaged = "✗",
          staged = "✚",
          unmerged = "═",
          renamed = "➜",
          untracked = "★"
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = ""
        }
      }
    }
  }
}

-- Set statusbar
local project_name_display = function ()
    local projections_available, Session = pcall(require, 'projections.session')
    if projections_available then
        local info = Session.info(vim.loop.cwd())
        if info ~= nil then
            -- local session_file_path = tostring(info.path)
            -- local project_workspace_patterns = info.project.workspace.patterns
            -- local project_workspace_path = tostring(info.project.workspace)
            local project_name = info.project.name
            return ' ' .. project_name
        end
    end
    local cwd = vim.loop.cwd()
    if cwd then
      return vim.fs.basename(cwd)
    else
      return nil
    end
end

vim.o.winbar="%f"
require('lualine').setup {
  sections = {
    lualine_b = { project_name_display, 'branch', 'diff', 'diagnostics'},
    lualine_x = { "overseer" },
  },
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
    globalstatus = true
  }
}

-- use global statusline
-- vim.o.laststatus=3

-- Remap space as leader key
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
-- vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
-- warning! this runs sometimes unintentionally when you are in insert mode and stop typing
-- vim.cmd [[
--   augroup YankHighlight
--     autocmd!
--     autocmd TextYankPost * silent! lua vim.highlight.on_yank()
--   augroup end
-- ]]

-- Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

require('diffview').setup({
  -- enhanced_diff_hl=true
})

-- Telescope
require('telescope').setup {
  defaults = {
    path_display = {
      filename_first = {
        reverse_directories = true
      }
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case"
    },
    file_ignore_patterns = {
      -- ignore dotnet generated folders in the file search
      "^bin/",
      "^obj/",
      "/bin/",
      "/obj/",
      -- ignore .git folders (usefull when using hidden=true option)
      "^.git/",
      "/.git/",
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      },
    }
  }
}

-- neogit
require('neogit').setup {
  integrations = {
    telescope = false,
    diffview = true
  }
}

-- mason setup
require("mason").setup()
require('mason-tool-installer').setup {

  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {

    -- you can turn off/on auto_update per tool
    { 'bash-language-server', auto_update = true },
    'lua-language-server',
    'yaml-language-server',
    'vim-language-server',
    'gopls',
    'terraform-ls',
    'lemminx', -- xml lsp
    'json-lsp',

    -- misc linter
    'shellcheck',
    'editorconfig-checker',
    -- you can pin a tool to a particular version
    -- { 'golangci-lint', version = '1.47.0' },

    -- rust
    'rust-analyzer',
    -- 'cargo-bsp',

    -- csharp
    'omnisharp', -- LSP
    'netcoredbg', -- DAP
    -- 'dotnet-bsp', -- BSP

    -- java
    'jdtls',
    'java-debug-adapter',
    'java-test',
    'gradle-bsp', -- BSP

    -- python
    'python-lsp-server',
  }
}

require("neotest").setup({
  adapters = {
    require("neotest-dotnet")
  },
  -- consumers = {
  --   overseer = require("neotest.consumers.overseer"),
  -- },
  icons = {
    -- Ascii:
    -- { "/", "|", "\\", "-", "/", "|", "\\", "-"},
    -- Unicode:
    -- { "", "🞅", "🞈", "🞉", "", "", "🞉", "🞈", "🞅", "", },
    -- {"◴" ,"◷" ,"◶", "◵"},
    -- {"◢", "◣", "◤", "◥"},
    -- {"◐", "◓", "◑", "◒"},
    -- {"◰", "◳", "◲", "◱"},
    -- {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"},
    -- {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"},
    -- {"⠋", "⠙", "⠚", "⠞", "⠖", "⠦", "⠴", "⠲", "⠳", "⠓"},
    -- {"⠄", "⠆", "⠇", "⠋", "⠙", "⠸", "⠰", "⠠", "⠰", "⠸", "⠙", "⠋", "⠇", "⠆"},
    -- { "⠋", "⠙", "⠚", "⠒", "⠂", "⠂", "⠒", "⠲", "⠴", "⠦", "⠖", "⠒", "⠐", "⠐", "⠒", "⠓", "⠋" },
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    passed = "✔",
    running = "🗘",
    failed = "✖",
    skipped = "ﰸ",
    unknown = "?",
  }
})


  -- hi LspReferenceRead link Visual cterm=bold ctermbg=red guibg=LightYellow
  -- hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
  -- hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
vim.api.nvim_exec2([[
  hi link LspReferenceRead Visual
  hi link LspReferenceText Visual
  hi link LspReferenceWrite Visual
]],
{
  output=true
})

-- custom config
-- require('completion-config')
-- vim.lsp.set_log_level("debug")
require('lsp-config')
require('dap-config')
require('formatter-config')
require('treesitter-config')
-- require('luasnip-config')

require('mini.surround').setup({})

-- require('nvim-test').setup {
--   run = true,                 -- run tests (using for debug)
--   commands_create = true,     -- create commands (TestFile, TestLast, ...)
--   filename_modifier = ":.",   -- modify filenames before tests run(:h filename-modifiers)
--   silent = false,             -- less notifications
--   term = "terminal",          -- a terminal to run ("terminal"|"toggleterm")
--   termOpts = {
--     direction = "vertical",   -- terminal's direction ("horizontal"|"vertical"|"float")
--     width = 96,               -- terminal's width (for vertical|float)
--     height = 24,              -- terminal's height (for horizontal|float)
--     go_back = false,          -- return focus to original window after executing
--     stopinsert = "auto",      -- exit from insert mode (true|false|"auto")
--     keep_one = true,          -- keep only one terminal for testing
--   },
--   runners = {               -- setup tests runners
--     cs = "nvim-test.runners.dotnet",
--     go = "nvim-test.runners.go-test",
--     rust = "nvim-test.runners.cargo-test",
--     javascript = "nvim-test.runners.mocha"
--   }
-- }

-- custom commands
-- -- open new terminal in the current files path
-- command Dterm new %:p:h | lcd % | terminal
-- command Sterm split | terminal
-- command Vterm vsplit | terminal
-- -- insert new uuid in current cursor location
-- -- format whole json file 
-- command FormatJson %!jq .

local ak = require('ak')
vim.api.nvim_create_user_command('GenUuid', function() ak.ui.insert_text(ak.uuid.new()) end, {desc="my: generate a new UUID and paste it on your cursors position."})
vim.api.nvim_create_user_command('EditConfig', "e ~/.config/nvim/init.lua", {desc="my: open init.lua file for editing "})
vim.api.nvim_create_user_command('UrlEncode', ak.ui.url.encode, {desc="my: convert a JWT token into plain JSON representation"})
vim.api.nvim_create_user_command('Base64Encode', ak.ui.base64.encode, {desc="my: convert a JWT token into plain JSON representation"})
vim.api.nvim_create_user_command('Base64Decode', ak.ui.base64.decode, {desc="my: convert a JWT token into plain JSON representation"})
vim.api.nvim_create_user_command('Base64UrlEncode', ak.ui.base64url.encode, {desc="my: convert a JWT token into plain JSON representation"})
vim.api.nvim_create_user_command('Base64UrlDecode', ak.ui.base64url.decode, {desc="my: convert a JWT token into plain JSON representation"})
vim.api.nvim_create_user_command('JwtDecode', ak.ui.jwt.decode, {desc="my: convert a JWT token into plain JSON representation"})

-- setup extra surround mappings
vim.keymap.set('x', 'S', function() require('mini.surround').add('visual') end, { noremap = true })
-- -- Make special mapping for "add surrounding for line"
-- vim.keymap.set('n', 'yss', 'ys_', { noremap = false })

-- setup nvim-tree keybinding
vim.keymap.set('n', '<leader>nr', require("nvim-tree.api").tree.reload, { desc="my: reload nvim-tree" })
vim.keymap.set('n', '<leader>nn', require("nvim-tree.api").tree.toggle, { desc="my: toggle nvim-tree" })
vim.keymap.set('n', '<leader>nf', function() require("nvim-tree.api").tree.open({find_file=true}) end, { desc="my: jump to current file in nvim-treee" })

-- remappings for easier switching between windows
-- vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h')
-- vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j')
-- vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k')
-- vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l')

-- hop mappings
vim.keymap.set('n', '<space>f', function() require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false }) end)
vim.keymap.set('n', '<space>F', function() require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false }) end)

-- Enable telescope fzf native
-- require('telescope').load_extension 'fzf'

-- telescope keybindins
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files({hidden=true,no_ignore=false,no_ignore_parent=false}) end)
vim.keymap.set('n', '<leader>fw', function() require('telescope.builtin').grep_string({search=vim.fn.expand('<cword>')}) end)
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers({show_all_buffers=true}) end)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>fgg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches)
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits)
vim.keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_implementations)
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols)
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps,{desc="my: find keybindings"})
vim.keymap.set('n', '<leader>fm', function() require('telescope.builtin').lsp_document_symbols({symbols={'method','function'}}) end)
vim.keymap.set('n', '<leader>fsw', require('telescope.builtin').lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fc', function() require('telescope.builtin').lsp_workspace_symbols({symbols='class'}) end)
vim.keymap.set("n", "<leader>fp", function() vim.cmd("Telescope projections") end, {desc="my: find projects"})
-- vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files({previewer = false}) end)
-- vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find)
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
-- vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
-- vim.keymap.set('n', '<leader>so', require('telescope.builtin').tags{ only_current_buffer = true })
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)
vim.keymap.set('n', '<space>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', 'Q', "<nop>")
vim.keymap.set('n', '<leader>gb', ":b#<CR>",{desc="my: switch between two last active buffers"})
vim.keymap.set('n', '<space>rw', ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/g<Left><Left>")

vim.cmd [[
  " configure terminal
  autocmd TermOpen * setlocal nonumber norelativenumber
]]

local my = {}
my.helper = {}
--- Find the root directory based on an indicating pattern
my.helper.find_root_dir = function(source, indicator_pattern)
  local fn_match_file = function (filename)
    local match = string.match(filename, indicator_pattern)
    if match then
      return true
    end
    return false
  end
  local path;
  local matches = vim.fs.find(fn_match_file, {
    path = source,
    upward = true,
    type = "directory"
  })
  if matches and #matches > 0 then
    path = vim.fn.fnamemodify(matches[1], ":p:h:h")
  end

  return path
end
-- Find git directory for current file
my.helper.get_git_dir = function ()
  return my.helper.find_root_dir(vim.fn.expand('%:p:h'), ".git")
end

-- -- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float() end, { noremap = true, silent = true })
vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, { noremap = true, silent = true })
vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, { noremap = true, silent = true })

-- neogit keymaps
-- vim.keymap.set('n', '<leader>gg', function() require("neogit").open({kind="replace",cwd=my.helper.get_git_dir()}) end, { desc = "my: open neogit overview" })
vim.keymap.set('n', '<leader>gg', function() require("neogit").open({cwd=my.helper.get_git_dir()}) end, { desc = "my: open neogit overview" })

-- setup dap key bindings
-- REPL (Read Evaluate Print Loop)
vim.keymap.set('n', '<leader>dd', require('dapui').toggle)
vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
vim.keymap.set('n', '<leader>dBc', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<leader>dBl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>dc', require('dap').continue)
vim.keymap.set('n', '<leader>dn', require('dap').step_over)
vim.keymap.set('n', '<leader>dp', require('dap').step_back)
vim.keymap.set('n', '<leader>dsi', require('dap').step_into)
vim.keymap.set('n', '<leader>dso', require('dap').step_out)
vim.keymap.set('n', '<leader>do', require('dap').repl.open)
vim.keymap.set('n', '<leader>drl', require('dap').run_last)
vim.keymap.set('n', '<leader>dt', function() require('neotest').run.run({vim.fn.expand('%'),strategy='dap'}) end, {desc="my: run test for current file in debug mode"})

-- keybinding for neotest
vim.keymap.set('n', '<leader>tt', require("neotest").summary.toggle, { desc="my: toggle test summary window"})
vim.keymap.set('n', '<leader>tn', require("neotest").run.run, { desc = "my: run nearest test"})
vim.keymap.set('n', '<leader>ts', require("neotest").run.stop)
vim.keymap.set('n', '<leader>ta', require("neotest").run.attach)
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run({vim.fn.expand('%')}) end, {desc="my: run test in current file"})
vim.keymap.set('n', '<leader>ts', function() require('neotest').run.run({suite=true}) end, {desc="my: run test for the whole suite"})
vim.keymap.set('n', '<leader>td', function() require('neotest').run.run({strategy='dap'}) end, {desc="my: run nearest test in debug mode"})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count=1,float=true}) end)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count=-1,float=true}) end)
vim.keymap.set('n', '<space>qq', vim.diagnostic.setqflist)
vim.keymap.set('n', '<space>qe', function() vim.diagnostic.setqflist({severity=vim.diagnostic.severity.ERROR}) end)
vim.keymap.set('n', '<space>ql', vim.diagnostic.setloclist)
-- quickfix list mappings
vim.keymap.set('n', '[q', ":cprev<CR>", {desc="my: go to previous item in the quickfix list"})
vim.keymap.set('n', ']q', ":cnext<CR>", {desc="my: go to next item in the quickfix list"})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>cf', function()
      vim.lsp.buf.format({ async = true})
    end, opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- setup compiler config for omnisharp
    if client and client.name == "omnisharp" then
      local workspaces = vim.lsp.buf.list_workspace_folders()
      if #workspaces == 1 then
        vim.cmd[[compiler dotnet]]
        vim.cmd {
          cmd = 'setlocal',
          args = { 'makeprg=dotnet\\ build\\ --no-cache\\ -nologo\\ -consoleloggerparameters:NoSummary\\ -consoleloggerparameters:ErrorsOnly\\ ' .. workspaces[1] }
        }
      end
    end
  end,
})

-- configure global logging 
require("bp.log").set_level(vim.log.levels.DEBUG)

local bsp = require("bsp")
bsp.setup({
  handlers = {

    ['cargo-bsp'] = function (workspace_dir, connection_details)
      -- cargo.toml in the current workspace (non recursive)
      for name, type in vim.fs.dir(workspace_dir) do
          if (type == "file") and
             name:match('^cargo.toml$') then
            return true
          end
      end

      return false
    end,

    ['gradle-bsp'] = function (workspace_dir, connection_details)
      -- gradle or gradlew.bat in the current workspace (non recursive)
      for name, type in vim.fs.dir(workspace_dir) do
          if (type == "file") and
             (name:match('^gradlew$') or name:match('^gradlew.bat$')) then
            return true
          end
      end

      return false
    end,

    ['dotnet-bsp'] = function (workspace_dir, connection_details)
      -- *.csproj or *.sln in the current workspace (non recursive)
      for name, type in vim.fs.dir(workspace_dir) do
          if (type == "file") and
             (name:match('.*.sln$') or name:match('.*.csproj$')) then
            return true
          end
      end

      return false
    end,

    ['*'] = function (workspace_dir, connection_details)
      -- .bsp/*.json
      for name, type in vim.fs.dir(workspace_dir .. "/.bsp/") do
          if (type == "file") and
             name:match('^.*%.json$') then
            print(" * fallback handler is used");
            return true
          end
      end

      return false
    end
  }
})

vim.api.nvim_create_autocmd("User",
{
  group = 'bsp',
  pattern = 'BspAttach',
  callback = function()
    vim.keymap.set('n', '<leader>bb', require('bsp').compile_build_target, { desc = 'my: compile build target with build server' })
    vim.keymap.set('n', '<leader>br', require('bsp').run_build_target, { desc = 'my: run build target with build server' })
    vim.keymap.set('n', '<leader>bt', require('bsp').test_build_target, { desc = 'my: test build target with build server' })
    vim.keymap.set('n', '<leader>bc', require('bsp').cleancache_build_target, { desc = 'my: clean cache build target with build server' })
  end
})

local progress = require("fidget.progress")
local handles = {}
vim.api.nvim_create_autocmd("User",
  {
    group = 'bsp',
    pattern = 'BspProgress:start',
    callback = function(ev)
      local data = ev.data
      local client = bsp.get_client_by_id(data.client_id)
      if client then
        ---@type bsp.TaskStartParams
        local result = ev.data.result
        local title = result.dataKind or "BSP-Task"
        local fallback_message = "started: " .. tostring(result.taskId.id)
        local message = result.message or fallback_message;

        local tokenId = data.client_id .. ":" .. result.taskId.id
        handles[tokenId] = progress.handle.create({
          token = tokenId,
          title = title,
          message = message,
          lsp_client = { name = client.name }
        })
      end
    end
  })

vim.api.nvim_create_autocmd("User",
  {
    group = 'bsp',
    pattern = 'BspProgress:progress',
    callback = function(ev)
      local data = ev.data
      local percentage = nil
      ---@type bsp.TaskProgressParams
      local result = ev.data.result
      if data.result and data.result.message then
        local message =
          (data.result.originId and ( data.result.originId .. ': ') .. data.result.message)
          or data.result.message
        if data.result.total and data.result.progress then
          percentage = math.max(percentage or 0, (data.result.progress / data.result.total * 100))
        end

        local tokenId = data.client_id .. ":" .. result.taskId.id
        local handle = handles[tokenId]
        if handle then
            local progressMessage = {
              token = tokenId,
              message = message,
              percentage = percentage
            }
            handle:report(progressMessage)
        end
      end
    end
  })

vim.api.nvim_create_autocmd("User",
  {
    group = 'bsp',
    pattern = 'BspProgress:finish',
    callback = function(ev)
      local data = ev.data
      ---@type bsp.TaskFinishParams
      local result = ev.data.result
      local tokenId = data.client_id .. ":" .. result.taskId.id
      local handle = handles[tokenId]
      if handle then
        handle:finish()
      end
    end
  })

-- vim: ts=2 sts=2 sw=2 et
