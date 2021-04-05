
" using vim-plug (junegunn/vim-plug)
call plug#begin(stdpath('data') . '/plugged')

" nvim lsp support
Plug 'neovim/nvim-lspconfig'
" plugin to install lsp servers
" Plug 'anott03/nvim-lspinstall'
Plug 'kabouzeid/nvim-lspinstall'
" complete support
 Plug 'hrsh7th/nvim-compe'
" Plug 'nvim-lua/completion-nvim'

" add snippets support
Plug 'norcalli/snippets.nvim'
"Plug 'hrsh7th/vim-vsnip'
"Plug 'hrsh7th/vim-vsnip-integ'

" Use release branch (recommend)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" treesitter install
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
"Plug 'nvim-treesitter/playground'

" color schemes
Plug 'tomasiser/vim-code-dark'
Plug 'rakr/vim-one'
Plug 'arcticicestudio/nord-vim'

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

" essential plugins
Plug 'tpope/vim-surround'

" debugger adapter protocoll support
Plug 'mfussenegger/nvim-dap'

" file explorer like NERDtree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

call plug#end()

" sync default registers with clipboard
set clipboard=unnamedplus

" fix yaml indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" set coloring for vifmrc
autocmd BufNewFile,BufRead vifmrc set syntax=vim

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

let b:coc_enabled=0

" differentiate between toolbox env and regular env
if filereadable(expand('/run/.toolboxenv'))
	echo "You are in a toolbox"

	" source ~/.config/nvim/coc-config.vimrc
	" source ~/.config/nvim/treesitter.vimrc
	
	" setup snippets support
	lua require'snippets'.snippets = {}
	" lua require'snippets'.use_suggested_mappings()

	" This variant will set up the mappings only for the *CURRENT* buffer.
	" lua require'snippets'.use_suggested_mappings(true)

	" There are only two keybindings specified by the suggested keymappings, which is <C-k> and <C-j>
	" They are exactly equivalent to:

	" <c-k> will either expand the current snippet at the word or try to jump to
	" the next position for the snippet.
	inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>

	" <c-j> will jump backwards to the previous field.
	" If you jump before the first field, it will cancel the snippet.
	inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>


	" Use completion-nvim in every buffer
	" autocmd BufEnter * lua require'completion'.on_attach()
	
	" setup nvim-comple support
	set completeopt=menuone,noselect
	set shortmess+=c
	" lua require'lspconfig'.rust_analyzer.setup{on_attach=require'completion'.on_attach}

	let g:compe = {}
	let g:compe.enabled = v:true
	let g:compe.autocomplete = v:true
	let g:compe.debug = v:false
	let g:compe.min_length = 1
	let g:compe.preselect = 'enable'
	let g:compe.throttle_time = 80
	let g:compe.source_timeout = 200
	let g:compe.incomplete_delay = 400
	let g:compe.max_abbr_width = 100
	let g:compe.max_kind_width = 100
	let g:compe.max_menu_width = 100
	let g:compe.documentation = v:true

	let g:compe.source = {}
	let g:compe.source.path = v:true
	let g:compe.source.buffer = v:true
	" let g:compe.source.calc = v:true
	" let g:compe.source.vsnip = v:true
	let g:compe.source.snippets_nvim = v:true
	let g:compe.source.nvim_lsp = v:true
	let g:compe.source.nvim_lua = v:true
	let g:compe.source.spell = v:true
	let g:compe.source.tags = v:true
	" let g:compe.source.treesitter = v:true
	" let g:compe.source.omni = v:true

	inoremap <silent><expr> <C-Space> compe#complete()
	inoremap <silent><expr> <CR>      compe#confirm('<CR>')
	inoremap <silent><expr> <C-e>     compe#close('<C-e>')
	inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
	inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

	luafile ~/.config/nvim/lsp-config.lua
else
	echo "You are NOT in a toolbox"
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
" nvim lsp plugin mappings
"""
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>



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

" nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

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
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" we can check if we using nvim in vscode plugin with exists('g:vscode')
