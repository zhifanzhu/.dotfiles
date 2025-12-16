set runtimepath+=~/.vim_runtime

" Disable vim 9's background color switching
let g:loaded_colorresp = 1

" For vundle
let vundle_file=findfile("~/.vim_vundle_rc.vim", ".;")
if !empty(vundle_file) && filereadable(vundle_file)
    source ~/.vim_vundle_rc.vim
endif

" Vim-Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif
call plug#begin()
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/linediff.vim'
Plug 'easymotion/vim-easymotion'
Plug 'majutsushi/tagbar'
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'skywind3000/asyncrun.vim'
Plug 'rust-lang/rust.vim'
Plug 'epheien/termdbg'
" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Plug 'davidhalter/jedi-vim'
" Plug 'neoclide/coc.nvim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'Chiel92/vim-autoformat'
" Plug 'tmhedberg/SimpylFold'
" Plug 'python-mode/python-mode', { 'branch': 'develop' }
" Plug 'cjrh/vim-conda'

" A Vim Plugin for Lively Previewing LaTeX PDF Output
" Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plug 'lervag/vimtex'
call plug#end()

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

" coc.vim
" source ~/.vim/.coc.vimrc

set t_Co=256
colorscheme gruvbox

set guifont=Monospace\ 12
set nocompatible
set number
set mouse=a
set splitbelow
set splitright
set autoindent " smartindent? cindent?
set showmatch
set switchbuf="" " for Ack.vim
set shiftwidth=4
set tabstop=4
set expandtab

syntax enable
filetype plugin on

set path+=**
set wildmenu
set exrc  " per project .vimrc
set tags=./.tags;,.tags

if has("unix")
  let s:uname = system("echo -n \"$(uname)\"") " Linux / Darwin
endif

if s:uname == 'Linux'  " For mac os, use Termdbg
    packadd! termdebug
    let g:termdebug_wide=1
endif

command! MakeTags :AsyncRun ctags -f .tags -R .
command! MakeCscope :AsyncRun cscope -f .cscope.out -R -b

" If we dont't have a local vimrc, then we set <F4> to execute single file.
" otherwise(non empty case), we don't set it here
let local_vimrc=findfile(".vimrc", ".")
if empty(local_vimrc)
    autocmd filetype python nnoremap <F4> :AsyncRun -save=1 -raw python3 %<CR>
    " autocmd filetype python set foldmethod=indent
    " autocmd filetype python set foldnestmax=2
    autocmd filetype c nnoremap <F4> :AsyncRun -save=1 gcc -O0 -g % -o %:r && echo Compilation complete && ./%:r<CR>
    if !empty(glob("/usr/bin/llvm-symbolizer-4.0"))
        autocmd filetype cpp nnoremap <F4> :AsyncRun -save=1
                    \ -mode=term -focus=0 -pos=right -cols=80
                    \ g++ -std=c++17 -Wall -O0 -g -fsanitize=address % -o %:r  
                    \ && echo Compilation complete && 
                    \ ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer-4.0 ./%:r<CR>
    elseif !empty(glob("/usr/local/opt/llvm/bin/llvm-symbolizer"))
        autocmd filetype cpp nnoremap <F4> :AsyncRun -save=1 
                    \ -mode=term -focus=0 -pos=right -cols=80
                    \ g++ -std=c++17 -Wall -O0 -g -DDEBUG -fsanitize=address % -o %:r  
                    \ && echo Compilation complete 
                    \ && ASAN_SYMBOLIZER_PATH=/usr/local/opt/llvm/bin/llvm-symbolizer ./%:r<CR>
    else
        autocmd filetype cpp nnoremap <F4> :AsyncRun -save=1 
                    \ -mode=term -focus=0 -pos=right -cols=80
                    \ g++ -std=c++17 -Wall -O0 -g -fsanitize=address % -o %:r  
                    \ && echo Compilation complete && ./%:r<CR>
    endif
    autocmd filetype cuda nnoremap <F4> :AsyncRun -save=1
                \ -mode=term -focus=0 -pos=right -cols=80
                \ nvcc -g -G -O0 -std=c++17 % -o %:r 
                \ && echo Compilation complete && ./%:r<CR>
    autocmd filetype lua nnoremap <F4> :w <bar> :AsyncRun lua %<CR>
    autocmd filetype go nnoremap <F4> :w <bar> :AsyncRun go run %<CR>
    autocmd filetype sh nnoremap <F4> :w <bar> :AsyncRun bash %<CR>
    autocmd filetype cool nnoremap <F4> :w <bar> :AsyncRun coolc % && spim %:r.s<CR>
    autocmd filetype rust nnoremap <F4> :w <bar> :AsyncRun (cd %:p:h && cargo run)<CR>
    autocmd filetype haskell nnoremap <F4> :w <bar> :AsyncRun ghc % -threaded && ./%:r<cr>
    autocmd FileType haskell set et ts=2 shiftwidth=2
    autocmd filetype javascript nnoremap <F4> :w <bar> :AsyncRun node %<cr>
    autocmd filetype javascript nnoremap <F4> :AsyncRun -save=1 
                \ -mode=term -focus=0 -pos=right -cols=80
                \ node %<CR>
endif
" let g:syntastic_cpp_compiler_options = ' -std=c++17'

" Filetype auto commands
autocmd filetype haskell set shiftwidth=2  tabstop=2

" Quickfix/Location window
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L

" AsyncRun.vim
" automatically open quickfix window when AsyncRun command is executed
" set the quickfix window 6 lines height.
let g:asyncrun_open = 7
map <leader>a :AsyncRun 
map <leader>g :AsyncRun ag 

" SimpylFold
" let g:SimpylFold_fold_import = 0

" Easymotion
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" CtrlP
let g:ctrlp_cmd = 'CtrlPMRUFiles'

" Tagbar
nnoremap <Leader>tt :TagbarToggle<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>

" NerdTree/NerdTreeTabs Settings
let g:NERDTreeWinPos = "left"
" nnoremap <Leader>nn :NERDTreeTabsToggle<cr>
" nnoremap <F8> :NERDTreeTabsToggle<cr>
nnoremap <F8> :NERDTreeToggle<cr>

" Turn off annoying ALE default sign column for c++17
let g:ale_linters = {'cpp': ['g++']}
let g:ale_lint_on_text_changed = 'normal'
let g:ale_cpp_clang_options = '  -std=c++17'
" let g:ale_lint_delay

" YouCompleteMe config
nnoremap <leader>] :YcmCompleter GoTo<cr>
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
" let g:ycm_path_to_python_interpreter = '/usr/bin/python3.8'

" Disable auto-pair
let g:AutoPairs={}

" Disable bufexplorer
let g:bufexplorer_version = "disabled"

" Find cscope
let cscope_file=findfile(".cscope.out", ".;")
if !empty(cscope_file) && filereadable(cscope_file)
    exe "cs add" cscope_file 
    source ~/.vim_runtime/my_plugins/cscope.vim
endif

" current line function info in python
nnoremap <C-g>f :echo cfi#format("%s", "")<CR>

""""""""""""""""""""""""
" Package: ALE

" Turn off annoying ALE default sign column for c++11
let g:ale_linters = {'cpp': ['g++']}
let g:ale_lint_on_text_changed = 'normal'
let g:ale_cpp_clang_options = '-std=c++17'
" let g:ale_lint_delay
let g:ale_cpp_gcc_options = ' -std=c++17 -Wall -Wno-sign-compare'

" turn YCM's linter off in favor of ALE
let g:ycm_show_diagnostics_ui = 0  
" alternatively, turn ALE off
" let g:ale_enabled = 0

" Package End: ALE
""""""""""""""""""""""""
 

""""""""""""""""""""""""
" Language: Cpp / C++

" matching c++ template
autocmd FileType cpp setlocal matchpairs+=<:>

" Language End: Cpp / C++
""""""""""""""""""""""""


""""""""""""""""""""""""
" Language: python

" vim python-mode
let g:pymode_python = 'python3'
" let g:pymode_virtualenv = "/home/damon/anaconda2"
let g:pymode_lint_checkers = ["pylint", ]
let g:pymode_lint_ignore = ["E501", "E111", "E114"]
let g:pymode_options_colorcolumn = 0

" python function list helper
command! ShowFunc :lvim /def\ ./ %<cr>:lopen<cr>
command! ShowClass :lvim /^class\ ./ %<cr>:lopen<cr>
command! Ipdb :normal Oimport ipdb; ipdb.set_trace()  # XXX BREAKPOINT

" Jedi
let g:jedi#auto_initialization = 0  " Please use local .vimrc
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = "<C-N>"
let g:jedi#goto_assignments_command = ""
autocmd filetype python nnoremap <C-]> :call jedi#goto()<CR>
" Set environment let g:jedi#environment_path = "/usr/bin/python3.9"

" Language End: python
""""""""""""""""""""""""

" Ack.vim
cnoreabbrev Ack Ack!
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
let g:ack_mappings = { "o": "<CR><C-W>j", "h": "h" }

" load my vim keymap
source ~/.vimrc.keymap

set secure
