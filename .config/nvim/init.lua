-- Install LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Add git related info in the signs columns and popups
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  -- git plugin
  {
    'TimUntersberger/neogit',
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
  'nvim-treesitter/playground',

  -- nvim lsp support
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim", -- for better integration with lspconfig
  "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- for easier installing tools

  -- specific for csharp allows goto definition for decompiled binaries
  "Hoffs/omnisharp-extended-lsp.nvim",

  -- Additional lua configuration, makes nvim stuff amazing
  'folke/neodev.nvim',

  -- complete support
  'hrsh7th/nvim-cmp', -- Autocompletion plugin
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'onsails/lspkind-nvim',
  'tjdevries/complextras.nvim',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip', -- Snippets plugin
  'rafamadriz/friendly-snippets', -- basic snippets
  {
    "danymat/neogen", -- documentation generation
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- custom formatters
  'mhartington/formatter.nvim',

  -- color schemes
  'tomasiser/vim-code-dark',
  'rakr/vim-one',
  'gbprod/nord.nvim',

  -- colorscheme helper
  'tjdevries/colorbuddy.nvim',

  -- colorizer (show colors for RGB and there like)
  'norcalli/nvim-colorizer.lua',

  -- comment plugins
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  --'tomtom/tcomment_vim',
  --'preservim/nerdcommenter',

  -- Plugin outside ~/.vim/plugged with post-update hook
  --'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' },
  --'junegunn/fzf.vim',

  -- lightline plugin for pretty statusline
  {
    'nvim-lualine/lualine.nvim', -- Fancier statusline
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true } -- for file icons
  },
  -- 'itchyny/lightline.vim',

  -- essential plugins,
  -- 'tpope/vim-surround',
  { 'echasnovski/mini.nvim', branch = 'stable' },

  -- debugger adapter protocoll support
  'mfussenegger/nvim-dap',
  { 'Pocco81/dap-buddy.nvim', branch = "dev" },
  'rcarriga/nvim-dap-ui',
  -- 'nvim-telescope/telescope-dap.nvim',

  -- unit test plugins
  -- 'klen/nvim-test',
  -- "616b2f/nvim-test",
  {
    "nvim-neotest/neotest",
    dependencies = {
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
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    }
  },
  {
    'gnikdroy/projections.nvim',
    config = function()
      require("projections").setup({
        workspaces = {                        -- Default workspaces to search for 
          { "~/devel/ext", { ".git" } },      -- devel/ext is a workspace. patterns = { ".git" }
          { "~/devel", { ".git" } },          -- devel is a workspace. patterns = { ".git" }
        },
      })
      require('telescope').load_extension('projections')
    end
  },

  {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
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
  'ray-x/lsp_signature.nvim',

  -- for easier resizing windows
  {"dimfred/resize-mode.nvim"},
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

-- diff customizations
vim.o.fillchars='diff:╱'

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
vim.g.nord_borders = true
vim.g.nord_contrast = true
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = false
vim.cmd[[colorscheme nord]]

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

require('diffview').setup({
  -- enhanced_diff_hl=true
})

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

        -- you can turn off/on auto_update per tool
        { 'bash-language-server', auto_update = true },
        'lua-language-server',
        'yaml-language-server',
        'vim-language-server',
        'gopls',
        'rust-analyzer',
        'terraform-ls',

        -- misc linter
        'shellcheck',
        'editorconfig-checker',
        -- you can pin a tool to a particular version
        -- { 'golangci-lint', version = '1.47.0' },

        -- csharp
        'omnisharp', -- LSP
        'netcoredbg', -- DAP

        -- java
        'jdtls',
        'java-debug-adapter',
        'java-test'

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
vim.api.nvim_create_user_command('OpenConfig', "e ~/.config/nvim/init.lua", {})

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

-- telescope keybindins
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>fw', function() require('telescope.builtin').grep_string({search=vim.fn.expand('<cword>')}) end)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>fgg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches)
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits)
vim.keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_implementations)
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols)
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps,{desc="find keybindings"})
vim.keymap.set('n', '<leader>fm', function() require('telescope.builtin').lsp_document_symbols({symbols={'method','function'}}) end)
vim.keymap.set('n', '<leader>fsw', require('telescope.builtin').lsp_workspace_symbols)
vim.keymap.set('n', '<leader>fc', function() require('telescope.builtin').lsp_workspace_symbols({symbols='class'}) end)
vim.keymap.set("n", "<leader>fp", function() vim.cmd("Telescope projections") end, {desc="find projects"})
-- vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files({previewer = false}) end)
-- vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find)
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
-- vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
-- vim.keymap.set('n', '<leader>so', require('telescope.builtin').tags{ only_current_buffer = true })
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)

vim.keymap.set('n', 'Q', "<nop>")
vim.keymap.set('n', '<leader>gb', ":b#<CR>",{desc="switch between two last active buffers"})
vim.keymap.set('n', '<space>rw', ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/g<Left><Left>")

-- -- custom commands
-- -- open new terminal in the current files path
-- command Dterm new %:p:h | lcd % | terminal
-- command Sterm split | terminal
-- command Vterm vsplit | terminal
-- -- insert new uuid in current cursor location
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
vim.keymap.set('n', '<leader>gg', require("neogit").open, { desc = "open neogit overview" })

-- keybinding for neotest
vim.keymap.set('n', '<leader>rn', require("neotest").run.run, { desc = "run nearest test"})
vim.keymap.set('n', '<leader>rs', require("neotest").run.stop)
vim.keymap.set('n', '<leader>ra', require("neotest").run.attach)
vim.keymap.set('n', '<leader>rf', function() require('neotest').run.run({vim.fn.expand('%')}) end)
vim.keymap.set('n', '<leader>rs', function() require('neotest').run.run({suite=true}) end)
vim.keymap.set('n', '<leader>rd', function() require('neotest').run.run({strategy='dap'}) end)

vim.keymap.set('n', '<leader>wr', require("resize-mode").start, { noremap = true, silent = true })

vim.keymap.set("n","<C-e>", ":TSHighlightCapturesUnderCursor<CR>")

-- vim.api.nvim_set_hl(0, 'DiffAdd', { bg='#A3BE8C'})
-- vim.api.nvim_set_hl(0, 'DiffDelete', { bg='#BF616A'})
-- vim.api.nvim_set_hl(0, 'DiffChange', { bg='#EBCB8B'})
-- vim.api.nvim_set_hl(0, 'DiffText', { bg='#D08770'})
-- vim.api.nvim_set_hl(0, 'DiffviewStatusModified', { fg='#EBCB8B'})
-- vim.api.nvim_set_hl(0, 'DiffviewStatusUnmerged', { fg='#EBCB8B'})
-- vim.api.nvim_set_hl(0, 'DiffviewFilePanelDeletions', { fg='#BF616A'})
-- vim.api.nvim_set_hl(0, 'DiffviewFilePanelInsertions', { fg='#A3BE8C'})

-- vim.api.nvim_set_hl(0, 'DiffAdd', { bg='#283B4D', fg='NONE' })
-- vim.api.nvim_set_hl(0, 'DiffChange', { bg='#283B4D', fg='NONE' })
-- vim.api.nvim_set_hl(0, 'DiffDelete', { bg='#3C2C3C', fg='#4d384d' })
-- vim.api.nvim_set_hl(0, 'DiffText', { bg='#365069', fg='NONE' })

-- vim: ts=2 sts=2 sw=2 et
