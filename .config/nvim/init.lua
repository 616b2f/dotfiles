-- use new loader
vim.loader.enable()

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
        -- "github:mason-org/mason-registry",
        "file:~/devel/mason-registry"
      },
      providers = {
        "mason.providers.client",
      },
    }
  },
  "williamboman/mason-lspconfig.nvim", -- for better integration with lspconfig
  "neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- for easier installing tools
  {
    'j-hui/fidget.nvim',
    opts = {
      notification = {
        override_vim_notify = false
      }
    }, -- `opts = {}` is the same as calling `require('fidget').setup({})`
    branch = "main"
  }, -- Useful status updates for LSP

  -- specific for csharp allows goto definition for decompiled binaries
  "Hoffs/omnisharp-extended-lsp.nvim",

  "mfussenegger/nvim-jdtls", -- specific for java, add some special config

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
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true } -- for file icons
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
  'ray-x/lsp_signature.nvim',

  -- for easier resizing windows
  {"dimfred/resize-mode.nvim"},

  -- vscode like task runner
  {
    'stevearc/overseer.nvim',
    opts = {},
  },

  { dir = "~/devel/bsp.nvim" },
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

-- show max width column, to gide you howlong the line should be
-- vim.o.colorcolumn = "80"

-- Set colorscheme
vim.o.termguicolors = true
require("nord").setup({
  diff = { mode = "fg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
})
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
            return '󱂵 ' .. project_name
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

require('diffview').setup({
  -- enhanced_diff_hl=true
})

-- Telescope
require('telescope').setup {
  defaults = {
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
-- require("mason").setup()
-- require'mason-tool-installer'.setup {
--
--   -- a list of all tools you want to ensure are installed upon
--   -- start; they should be the names Mason uses for each tool
--   ensure_installed = {
--
--     -- you can turn off/on auto_update per tool
--     { 'bash-language-server', auto_update = true },
--     'lua-language-server',
--     'yaml-language-server',
--     'vim-language-server',
--     'gopls',
--     'rust-analyzer',
--     'terraform-ls',
--
--     -- misc linter
--     'shellcheck',
--     'editorconfig-checker',
--     -- you can pin a tool to a particular version
--     -- { 'golangci-lint', version = '1.47.0' },
--
--     -- csharp
--     'omnisharp', -- LSP
--     'netcoredbg', -- DAP
--
--     -- java
--     'jdtls',
--     'java-debug-adapter',
--     'java-test',
--
--     -- python
--     'python-lsp-server'
--   }
-- }

-- Setup neovim specific lua support
require('neodev').setup({
  library = { plugins = { "neotest" }, types = true },
})

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
  quit_key = "<CR>",
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
-- -- open new terminal in the current files path
-- command Dterm new %:p:h | lcd % | terminal
-- command Sterm split | terminal
-- command Vterm vsplit | terminal
-- -- insert new uuid in current cursor location
-- -- format whole json file 
-- command FormatJson %!jq .
vim.api.nvim_create_user_command('GenUuid', "r !uuidgen | tr -d '\n'", {desc="my: generate a new UUID and paste it on your cursors position."})
vim.api.nvim_create_user_command('EditConfig', "e ~/.config/nvim/init.lua", {desc="my: open init.lua file for editing "})

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

-- neogen mappings
vim.keymap.set("n", "<space>df", require('neogen').generate)

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

vim.keymap.set('n', '<leader>wr', require("resize-mode").start, { noremap = true, silent = true })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist)
vim.keymap.set('n', '<space>qe', function() vim.diagnostic.setqflist({severity=vim.diagnostic.severity.ERROR}) end)
vim.keymap.set('n', '<space>ql', vim.diagnostic.setloclist)

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
local log = require("bp.log")
log.set_level(vim.log.levels.DEBUG)

local bsp = require("bsp")
bsp.setup()

vim.api.nvim_create_autocmd("User",
{
  group = 'bsp',
  pattern = 'BspAttach',
  callback = function()
    local opts = {}
    vim.keymap.set('n', '<leader>bb', bsp.compile_build_target, opts)
    vim.keymap.set('n', '<leader>bt', require('bsp').test_build_target, opts)
    vim.keymap.set('n', '<leader>bc', require('bsp').cleancache_build_target, opts)
  end
})

local register_bsp_progress_handle = function ()
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
          local title = "BSP-Task"
          if result.dataKind then
            title = result.dataKind
          end
          local message = "started: " .. tostring(result.taskId.id)

          handles[result.taskId.id] = progress.handle.create({
            token = result.taskId.id,
            title = title,
            message = (result.message or message),
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
        local percentage = 0
        ---@type bsp.TaskStartParams
        local result = ev.data.result
        if data.result and data.result.message then
          local message =
            data.result.message
            and (data.result.originId and ( data.result.originId .. ': ') .. data.result.message)
            or data.result.title
          if data.result.total and data.result.progress then
            percentage = math.max(percentage or 0, (data.result.progress / data.result.total * 100))
          end
          local handle = handles[result.taskId.id]
          if handle then
              local progressMessage = {
                token = result.taskId.id,
                message = message,
                percentage = percentage
              }
              -- print(vim.inspect(progressMessage))
              -- print(vim.inspect(result))
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
        ---@type bsp.TaskStartParams
        local result = ev.data.result
        local handle = handles[result.taskId.id]
        -- You can also cancel the task (errors if not cancellable)
        -- handle:cancel()
        -- Or mark it as complete (updates percentage to 100 automatically)
        if handle then
          handle:finish()
        end
      end
    })
end

register_bsp_progress_handle()

-- vim: ts=2 sts=2 sw=2 et
