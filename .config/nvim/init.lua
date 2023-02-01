-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager

  -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management

  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- git plugin
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim'
    }
  }
  -- use 'tpope/vim-fugitive' -- Git commands in nvim
  --use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  --use 'sindrets/diffview.nvim'

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
  -- use 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  -- We recommend updating the parsers on update
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Additional textobjects for treesitter
  use 'nvim-treesitter/playground'

  -- nvim lsp support
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim", -- for better integration with lspconfig
    "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- for easier installing tools

    -- specific for csharp allows goto definition for decompiled binaries
    "Hoffs/omnisharp-extended-lsp.nvim",

    -- Additional lua configuration, makes nvim stuff amazing
    'folke/neodev.nvim',
  }

  -- complete support
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'onsails/lspkind-nvim'
  use 'tjdevries/complextras.nvim'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'rafamadriz/friendly-snippets' -- basic snippets
  use {
    "danymat/neogen", -- documentation generation
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  }

  -- custom formatters
  use 'mhartington/formatter.nvim'

  -- color schemes
  use 'tomasiser/vim-code-dark'
  use 'rakr/vim-one'
  use 'arcticicestudio/nord-vim'
  -- use 'mjlbach/onedark.nvim' -- Theme inspired by Atom
  -- colorscheme helper
  use 'tjdevries/colorbuddy.nvim'

  -- colorizer (show colors for RGB and there like)
  use 'norcalli/nvim-colorizer.lua'

  -- comment plugins
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  --use 'tomtom/tcomment_vim'
  --use 'preservim/nerdcommenter'

  -- Plugin outside ~/.vim/plugged with post-update hook
  --use 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  --use 'junegunn/fzf.vim'

  -- lightline plugin for pretty statusline
  use {
    'nvim-lualine/lualine.nvim', -- Fancier statusline
    requires = { 'kyazdani42/nvim-web-devicons', opt = true } -- for file icons
  }
  -- use 'itchyny/lightline.vim'

  -- essential plugins
  -- use 'tpope/vim-surround'
  use { 'echasnovski/mini.nvim', branch = 'stable' }

  -- debugger adapter protocoll support
  use 'mfussenegger/nvim-dap'
  use { 'Pocco81/dap-buddy.nvim', branch = "dev" }
  use 'rcarriga/nvim-dap-ui'
  -- use 'nvim-telescope/telescope-dap.nvim'

  -- unit test plugins
  -- use 'klen/nvim-test'
  -- use "616b2f/nvim-test"
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  }
  use({
    "Issafalcon/neotest-dotnet",
    requires = {
      {
        "nvim-neotest/neotest",
      },
    }
  })

  -- file explorer like NERDtree
  use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      }
  }

  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup()
    end
  }
  -- use "nvim-telescope/telescope-file-browser.nvim"

  -- terraform plugin
  use 'hashivim/vim-terraform'

  -- nice helper for registers
  use {
    'tversteeg/registers.nvim',
    config = function ()
      require("registers").setup()
    end,
  }

  -- plugin to show function signatures in a better way
  use 'ray-x/lsp_signature.nvim'

  -- for easier resizing windows
  use {"dimfred/resize-mode.nvim"}

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- enable filetype.lua and disable filetype.vim
vim.g.do_filetype_lua = 1

-- dont fix end of line in files
vim.g.fixendofline = false

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
vim.o.list = true

-- reproduce the indentation of the previous line:
vim.o.autoindent = true
-- indent after { and so on
vim.o.smartindent = true

-- fix indentation for file types
vim.cmd [[
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
    autocmd BufNewFile,BufRead *.csproj setlocal ts=2 sts=2 sw=2 expandtab
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

vim.o.colorcolumn = "80"

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme nord]]

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
          file = false,
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
vim.o.winbar="%f"
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
    globalstatus = true
  }
}

require('neogen').setup
{
  snippet_engine = 'luasnip',
  languages = {
    cs = {
      template = {
        annotation_convention = 'xmldoc' -- for a full list of annotation_conventions, see supported-languages below,
      }
    },
  }
}

-- use global statusline
-- vim.o.laststatus=3

-- Enable Comment.nvim
require('Comment').setup()

-- Remap space as leader key
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
-- vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })


-- setup lsp_signature
-- this needs to be called before we configure lsp servers
require('lsp_signature').setup({floating_window_above_cur_line = true})

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

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

-- neogit
require('neogit').setup {
  integrations = {
    diffview = true
  }
}

-- Telescope
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      -- ignore dotnet generated folders in the file search
      "^bin/",
      "^obj/",
      "/bin/",
      "/obj/",
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- mason setup
require("mason").setup()
require'mason-tool-installer'.setup {

    -- a list of all tools you want to ensure are installed upon
    -- start; they should be the names Mason uses for each tool
    ensure_installed = {

        -- LSP
        -- you can turn off/on auto_update per tool
        { 'bash-language-server', auto_update = true },
        'lua-language-server',
        'yaml-language-server',
        'vim-language-server',
        'omnisharp',
        'gopls',
        'rust-analyzer',
        'terraform-ls',

        -- linter
        'shellcheck',
        'editorconfig-checker',
        -- you can pin a tool to a particular version
        -- { 'golangci-lint', version = '1.47.0' },

        -- DAP
        'netcoredbg',

        -- 'luacheck',
        -- 'stylua',
        -- 'gofumpt',
        -- 'golines',
        -- 'gomodifytags',
        -- 'gotests',
        -- 'impl',
        -- 'json-to-struct',
        -- 'misspell',
        -- 'revive',
        -- 'shfmt',
        -- 'staticcheck',
        -- 'vint',
    }
}

-- Setup neovim specific lua support
require('neodev').setup({
  library = { plugins = { "neotest" }, types = true },
})

require("neotest").setup({
  adapters = {
    require("neotest-dotnet")
  },
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

-- custom config
require('completion-config')
require('lsp-config')
require('dap-config')
require('formatter-config')
require('treesitter-config')
require('luasnip-config')

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

require("resize-mode").setup {
  horizontal_amount = 9,
  vertical_amount = 5,
  quit_key = "<ESC>",
  enable_mapping = true,
  resize_keys = {
      "h", -- increase to the left
      "j", -- increase to the bottom
      "k", -- increase to the top
      "l", -- increase to the right
      "H", -- decrease to the left
      "J", -- decrease to the bottom
      "K", -- decrease to the top
      "L"  -- decrease to the right
  }
}

-- custom commands
vim.api.nvim_create_user_command('GenUuid', "r !uuidgen | tr -d '\n'", {})

-- setup extra surround mappings
vim.keymap.set('x', 'S', function() require('mini.surround').add('visual') end, { noremap = true })
-- -- Make special mapping for "add surrounding for line"
-- vim.keymap.set('n', 'yss', 'ys_', { noremap = false })

-- setup nvim-tree keybinding
vim.keymap.set('n', '<leader>nr', require("nvim-tree.api").tree.reload)
vim.keymap.set('n', '<leader>n', require("nvim-tree.api").tree.toggle)
vim.keymap.set('n', '<leader>nf', function() require("nvim-tree.api").tree.open({find_file=true}) end)

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

-- remappings for easier switching between windows
-- vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h')
-- vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j')
-- vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k')
-- vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l')

-- hop mappings
vim.keymap.set('n', '<space>f', function() require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false }) end)
vim.keymap.set('n', '<space>F', function() require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false }) end)

-- neogen mappings
vim.keymap.set("n", "<space>df", require('neogen').generate)

-- Enable telescope fzf native
-- require('telescope').load_extension 'fzf'

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>fw', function() require('telescope.builtin').grep_string({search=vim.fn.expand('<cword>')}) end)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>fgg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches)
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits)
vim.keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_implementations)
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols)
vim.keymap.set('n', '<leader>fm', function() require('telescope.builtin').lsp_document_symbols({symbols={'method','function'}}) end)
vim.keymap.set('n', '<leader>fsw', require('telescope.builtin').lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fc', function() require('telescope.builtin').lsp_workspace_symbols({symbols='class'}) end)
-- vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files({previewer = false}) end)
-- vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find)
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
-- vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
-- vim.keymap.set('n', '<leader>so', require('telescope.builtin').tags{ only_current_buffer = true })
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)

vim.keymap.set('n', 'Q', "<nop>")
vim.keymap.set('n', '<space>rw', ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/g<Left><Left>")

-- -- custom commands
-- -- open new terminal in the current files path
-- command Dterm new %:p:h | lcd % | terminal
-- command Sterm split | terminal
-- command Vterm vsplit | terminal
-- -- insert new uuid in current cursor location
-- command Nuuid exe 'norm i' . system("uuidgen | tr -d '\n'")
-- -- format whole json file 
-- command FormatJson %!jq .
vim.cmd [[
  " configure terminal
  autocmd TermOpen * setlocal nonumber norelativenumber
]]

-- -- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float() end, { noremap = true, silent = true })
vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, { noremap = true, silent = true })
vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, { noremap = true, silent = true })

-- neogit keymaps
vim.keymap.set('n', '<leader>g', require("neogit").open, { noremap = true, silent = true })

-- keybinding for neotest
vim.keymap.set('n', '<leader>rn', require("neotest").run.run)
vim.keymap.set('n', '<leader>rs', require("neotest").run.stop)
vim.keymap.set('n', '<leader>ra', require("neotest").run.attach)
vim.keymap.set('n', '<leader>rf', function() require('neotest').run.run({vim.fn.expand('%')}) end)
vim.keymap.set('n', '<leader>rd', function() require('neotest').run.run({strategy='dap'}) end)

vim.keymap.set('n', '<leader>wr', require("resize-mode").start, { noremap = true, silent = true })
-- vim: ts=2 sts=2 sw=2 et
