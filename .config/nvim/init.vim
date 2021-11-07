
" using vim-plug (junegunn/vim-plug)
call plug#begin(stdpath('data') . '/plugged')

" nvim lsp support
Plug 'neovim/nvim-lspconfig'
" plugin to install lsp servers
Plug 'williamboman/nvim-lsp-installer'

" complete support
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind-nvim'
Plug 'tjdevries/complextras.nvim'

" add snippets support
" Plug 'norcalli/snippets.nvim'
"Plug 'hrsh7th/vim-vsnip'
"Plug 'hrsh7th/vim-vsnip-integ'

" custom formatters
Plug 'mhartington/formatter.nvim'

" treesitter install
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
"Plug 'nvim-treesitter/playground'

" color schemes
Plug 'tomasiser/vim-code-dark'
Plug 'rakr/vim-one'
Plug 'arcticicestudio/nord-vim'
" colorscheme helper
Plug 'tjdevries/colorbuddy.nvim'

" colorizer (show colors for RGB and there like)
Plug 'norcalli/nvim-colorizer.lua'

" comment plugins
Plug 'tomtom/tcomment_vim'
"Plug 'preservim/nerdcommenter'

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'

" lightline plugin for pretty statusline
Plug 'itchyny/lightline.vim'

" git plugin
Plug 'tpope/vim-fugitive'
" try out
"Plug 'sindrets/diffview.nvim'


" essential plugins
Plug 'tpope/vim-surround'

" debugger adapter protocoll support
Plug 'mfussenegger/nvim-dap'
Plug 'Pocco81/DAPInstall.nvim'
Plug 'rcarriga/nvim-dap-ui'

" file explorer like NERDtree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" telescope plugins
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" terraform plugin
Plug 'hashivim/vim-terraform'

" nice helper for registers
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

" plugin to show function signatures in a better way
Plug 'ray-x/lsp_signature.nvim'

call plug#end()

" sync default registers with clipboard
set clipboard=unnamedplus

"""
" set default tab to spaces
"""
" length of an actual \t character:
set tabstop=4
" length to use when editing text (eg. TAB and BS keys)
" (0 for ‘tabstop’, -1 for ‘shiftwidth’):
set softtabstop=-1
" length to use when shifting text (eg. <<, >> and == commands)
" (0 for ‘tabstop’):
set shiftwidth=0
" round indentation to multiples of 'shiftwidth' when shifting text
" (so that it behaves like Ctrl-D / Ctrl-T):
set shiftround

" if set, only insert spaces; otherwise insert \t and complete with spaces:
set expandtab

" reproduce the indentation of the previous line:
set autoindent
" keep indentation produced by 'autoindent' if leaving the line blank:
"set cpoptions+=I
" try to be smart (increase the indenting level after ‘{’,
" decrease it after ‘}’, and so on):
"set smartindent
" a stricter alternative which works better for the C language:
"set cindent

" fix yaml indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=4 sts=4 sw=0 expandtab
autocmd FileType groovy setlocal ts=4 sts=4 sw=0 expandtab

" set coloring for vifmrc
autocmd BufNewFile,BufRead vifmrc set syntax=vim

" this is needed for LSP terraform server to work
autocmd BufNewFile,BufRead *.tf,*.tfvars set filetype=terraform

" set scheme
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (has("nvim"))
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
set termguicolors
endif
"
"colorscheme codedark
" colorscheme one
" set background=dark " for the dark version
colorscheme nord

" show line numbers
set nu

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

"""
" setup lsp_signature
"""
" this needs to be called before we configure lsp servers
lua require'lsp_signature'.setup({floating_window_above_cur_line = true})

luafile ~/.config/nvim/completion.lua
luafile ~/.config/nvim/lsp-config.lua
luafile ~/.config/nvim/dap-config.lua
luafile ~/.config/nvim/formatter.lua
luafile ~/.config/nvim/treesitter.lua

""" setup dap key bindings
""" REPL (Read Evaluate Print Loop)
nnoremap <leader>dd  <cmd>lua require("dapui").toggle()<cr>
nnoremap <leader>db  <cmd>lua require('dap').toggle_breakpoint()<cr>
nnoremap <leader>dBc <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <leader>dBl <cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <leader>dc  <cmd>lua require('dap').continue()<cr>
nnoremap <leader>dn <cmd>lua require('dap').step_over()<cr>
nnoremap <leader>dp <cmd>lua require('dap').step_back()<cr>
nnoremap <leader>dsi <cmd>lua require('dap').step_into()<cr>
nnoremap <leader>dso <cmd>lua require('dap').step_out()<cr>
nnoremap <leader>do  <cmd>lua require('dap').repl.open()<cr>
nnoremap <leader>drl <cmd>lua require('dap').run_last()<cr>

if exists('g:vscode')
    """ VSCode extension
    nnoremap gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
    nnoremap gen <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
    nnoremap gef <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
    nnoremap gep <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
else
    """ ordinary neovim
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
"if has("patch-8.1.1564")
"  " Recently vim can merge signcolumn and number column into one
"  set signcolumn=number
"else
"  set signcolumn=yes
"endif

"""
" nvim-tree.lua plugin settings
"""
" lua << EOF
" require'nvim-web-devicons'.setup {
"  -- globally enable default icons (default to false)
"  -- will get overriden by `get_icons` option
"  default = true;
" }
" EOF
lua require'nvim-web-devicons'.setup()

let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_add_trailing = 1
" let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 0,
    \ }

" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✚",
    \   'unmerged': "═",
    \   'renamed': "➜",
    \   'untracked': "★"
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': ""
    \   }
    \ }

lua require'nvim-tree'.setup {
    \ update_focused_file = {
    \     update_cwd = false
    \   }
    \ }

" nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>nf :NvimTreeFindFile<CR>

set termguicolors " this variable must be enabled for colors to be applied properly

"""
" lightline config
"""
let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'gitbranch': 'FugitiveHead',
	\   'filename': 'LightlineFilename',
	\ },
	\ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"""
" Telescope config
"""

" Find files using Telescope command-line sugar.
" nnoremap <leader>ff <cmd>Telescope find_files<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fw <cmd>lua require('telescope.builtin').grep_string({search=vim.fn.expand('<cword>')})<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fgb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>fgc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>fi <cmd>lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>fsm <cmd>lua require('telescope.builtin').lsp_document_symbols({symbols='method'})<cr>
nnoremap <leader>fsw <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
nnoremap <leader>fsc <cmd>lua require('telescope.builtin').lsp_workspace_symbols({symbols='class'})<cr>

"""
" remappings for easier switching between windows
"""
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

"""
" custom commands
"""

" configure terminal
autocmd TermOpen * setlocal nonumber norelativenumber
" open new terminal in the current files path
command Dterm new %:p:h | lcd % | terminal
command Sterm split | terminal
command Vterm vsplit | terminal

" insert new uuid in current cursor location
command Nuuid exe 'norm i' . system("uuidgen | tr -d '\n'")
" format whole json file 
command FormatJson %!jq .

"set list | set lcs+=space:·

" we can check if we using nvim in vscode plugin with exists('g:vscode')
