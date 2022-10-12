-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
   packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
   vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager

  -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management

  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-lua/popup.nvim'

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
  use "klen/nvim-test"

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

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- enable filetype.lua and disable filetype.vim
vim.g.do_filetype_lua = 1

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

-- if set, only insert spaces; otherwise insert \t and complete with spaces:
vim.o.expandtab=true

-- show special characters like tabs and trailing spaces
vim.o.list=true

-- reproduce the indentation of the previous line:
vim.o.autoindent=true
-- keep indentation produced by 'autoindent' if leaving the line blank:
--set cpoptions+=I
-- try to be smart (increase the indenting level after ‘{’,
-- decrease it after ‘}’, and so on):
--set smartindent
-- a stricter alternative which works better for the C language:
--set cindent

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

vim.api.nvim_set_keymap('n', '<leader>r', [[<cmd>NvimTreeRefresh<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>n', [[<cmd>NvimTreeToggle<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nf', [[<cmd>NvimTreeFindFile<CR>]], { noremap = true, silent = true })

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

-- setup dap key bindings
-- REPL (Read Evaluate Print Loop)
vim.api.nvim_set_keymap('n', '<leader>dd', [[<cmd>lua require('dapui').toggle()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>db', [[<cmd>lua require('dap').toggle_breakpoint()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dBc', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dBl', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', [[<cmd>lua require('dap').continue()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dn', [[<cmd>lua require('dap').step_over()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', [[<cmd>lua require('dap').step_back()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dsi', [[<cmd>lua require('dap').step_into()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dso', [[<cmd>lua require('dap').step_out()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>do', [[<cmd>lua require('dap').repl.open()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>drl', [[<cmd>lua require('dap').run_last()<CR>]], { noremap = true, silent = true })

-- remappings for easier switching between windows
-- vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l', { noremap = true, silent = true })

-- hop mappings
vim.api.nvim_set_keymap('n', '<space>f', [[<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>F', [[<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<CR>]], { noremap = true, silent = true })

-- neogen mappings
vim.api.nvim_set_keymap("n", "<space>df", ":lua require('neogen').generate()<CR>", { noremap = true, silent = true })

-- Enable telescope fzf native
-- require('telescope').load_extension 'fzf'

vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fw', [[<cmd>lua require('telescope.builtin').grep_string({search=vim.fn.expand('<cword>')})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgb', [[<cmd>lua require('telescope.builtin').git_branches()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgc', [[<cmd>lua require('telescope.builtin').git_commits()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fs', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fm', [[<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols={'method','function'}})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fsw', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols({symbols='class'})<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

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
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- neogit keymaps
vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua require("neogit").open()<CR>', { noremap = true, silent = true })

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

-- custom config
require('completion-config')
require('lsp-config')
require('dap-config')
require('formatter-config')
require('treesitter-config')
require('luasnip-config')
-- require('snippets-config')
-- require('luasnip-config')

require('mini.surround').setup({
  -- vim-surround style mappings
  custom_surroundings = {
    ['('] = {
      input = { find = '%(%s-.-%s-%)', extract = '^(.%s*).-(%s*.)$' },
      output = { left = '( ', right = ' )' },
    },
    ['['] = {
      input = { find = '%[%s-.-%s-%]', extract = '^(.%s*).-(%s*.)$' },
      output = { left = '[ ', right = ' ]' },
    },
    ['{'] = {
      input = { find = '{%s-.-%s-}', extract = '^(.%s*).-(%s*.)$' },
      output = { left = '{ ', right = ' }' },
    },
    ['<'] = {
      input = { find = '<%s-.-%s->', extract = '^(.%s*).-(%s*.)$' },
      output = { left = '< ', right = ' >' },
    },
    S = {
      -- lua bracketed string mapping
      -- 'ysiwS'  foo -> [[foo]]
      input = { find = '%[%[.-%]%]', extract = '^(..).*(..)$' },
      output = { left = '[[', right = ']]' },
    },
  },
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = 'sf',
    find_left = 'sF',
    highlight = 'gs',     -- hijack 'gs' (sleep) for highlight
    replace = 'cs',
    update_n_lines = '',  -- bind for updating 'config.n_lines'
  },
  -- Number of lines within which surrounding is searched
  n_lines = 62,

  -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
  highlight_duration = 2000,

  -- How to search for surrounding (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
  search_method = 'cover_or_next',
})

-- Remap adding surrounding to Visual mode selection
vim.api.nvim_set_keymap('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true })

-- unmap config generated `ys` mapping, prevents visual mode yank delay
if vim.keymap then
  vim.keymap.del("x", "ys")
else
  vim.cmd("xunmap ys")
end

-- Make special mapping for "add surrounding for line"
vim.api.nvim_set_keymap('n', 'yss', 'ys_', { noremap = false })

require('nvim-test').setup {
  run = true,                 -- run tests (using for debug)
  commands_create = true,     -- create commands (TestFile, TestLast, ...)
  filename_modifier = ":.",   -- modify filenames before tests run(:h filename-modifiers)
  silent = false,             -- less notifications
  term = "terminal",          -- a terminal to run ("terminal"|"toggleterm")
  termOpts = {
    direction = "vertical",   -- terminal's direction ("horizontal"|"vertical"|"float")
    width = 96,               -- terminal's width (for vertical|float)
    height = 24,              -- terminal's height (for horizontal|float)
    go_back = false,          -- return focus to original window after executing
    stopinsert = "auto",      -- exit from insert mode (true|false|"auto")
    keep_one = true,          -- keep only one terminal for testing
  },
  runners = {               -- setup tests runners
    cs = "nvim-test.runners.dotnet",
    go = "nvim-test.runners.go-test",
  }
}

-- require('nvim-test.runners.dotnet'):setup {
--     command = "dotnet",
--     args = { "test", "-v", "normal" },
-- 
--     file_pattern = "\\v(test?/.*|Tests)\\.(cs)$",
--     find_files = { "{name}.test.{ext}", "Tests.{ext}" },                  -- find testfile for a file
-- 
--     -- file_pattern = "\\v(__tests__/.*|(spec|test))\\.(js|jsx|coffee|ts|tsx)$",   -- determine whether a file is a testfile
--     -- find_files = { "{name}.test.{ext}", "{name}.spec.{ext}" },                  -- find testfile for a file
-- 
--     -- filename_modifier = nil,                                                    -- modify filename before tests run (:h filename-modifiers)
--     -- working_directory = nil,                                                    -- set working directory (cwd by default)
--   }
-- 
-- require('nvim-test.runners.go-test'):setup {
--     command = "go",
--     args = { "test", "-v" },
-- 
--     file_pattern = "\\v([^.]+_test)\\.go$",   -- determine whether a file is a testfile
--     find_files = { "{name}_test.go" },                  -- find testfile for a file
-- 
--     -- filename_modifier = nil,                                                    -- modify filename before tests run (:h filename-modifiers)
--     -- working_directory = nil,                                                    -- set working directory (cwd by default)
--   }

-- -- LSP settings
-- local lspconfig = require 'lspconfig'
-- local on_attach = function(_, bufnr)
--   local opts = { noremap = true, silent = true }
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
--   vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
-- end

-- custom commands
vim.api.nvim_create_user_command('GenUuid', "r !uuidgen | tr -d '\n'", {})

-- vim: ts=2 sts=2 sw=2 et
