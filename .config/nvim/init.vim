
" using vim-plug (junegunn/vim-plug)
call plug#begin(stdpath('data') . '/plugged')

" Use release branch (recommend)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'

" essential plugins
Plug 'tpope/vim-surround'

call plug#end()

" sync default registers with clipboard
set clipboard=unnamedplus

" fix yaml indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" we can check if we using nvim in vscode plugin with exists('g:vscode')
