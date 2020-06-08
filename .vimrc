if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf'
    Plug 'tpope/vim-sensible'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'vim-airline/vim-airline'
" Initialize plugin system
call plug#end()

set number
set list
set mouse=n
set mouse+=v
set visualbell


" Temp Files
set nobackup                    " No backup file
set noswapfile                  " No swap file

" Search
set incsearch                   " Incremental search
set nohlsearch                  " No Highlight matches
set ignorecase                  " Case-insensitive search...
set smartcase                   " ...unless search contains uppercase letter

" Indentation
set smarttab                    " Better tabs
set smartindent                 " Insert new level of indentation
set autoindent                  " Copy indentation from previous line
set tabstop=4                   " Columns a tab counts for
set softtabstop=4               " Columns a tab inserts in insert mode
set shiftwidth=4                " Columns inserted with the reindent operations
set shiftround                  " Always indent by multiple of shiftwidth
set expandtab                   " Always use spaces instead of tabs

command -nargs=* MMake :make! <q-args><bar>copen
command! BW :bn|:bd#

let mapleader = ","
nnoremap <Leader>g :grep! -sI -in --exclude-dir='.git' '<cword>' -R .
vnoremap <Leader>g "vy<Cr>:exec "grep! " getreg("v")"--exclude-dir='.git' -RIisn ."
nnoremap <silent> ) :cnext<Cr>
nnoremap <silent> ( :cprevious<Cr>
nnoremap <silent> > :bnext<Cr>
nnoremap <silent> < :bprev<Cr>
nnoremap <silent> <Leader>w :BW<Cr>



" Find file in current directory and edit it.
function! Find(name)
   let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
"   " replace above line with below one for gvim on windows
"   " let l:list=system("find . -name ".a:name." | perl -ne \"print
"   qq{$.\\t$_}\"")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

" autosave delay, cursorhold trigger, default: 4000ms
setl updatetime=300
" highlight the word under cursor (CursorMoved is inperformant)
highlight WordUnderCursor cterm=underline gui=underline
autocmd CursorHold * call HighlightCursorWord()
function! HighlightCursorWord()
    " if hlsearch is active, don't overwrite it!
    let search = getreg('/')
    let cword = expand('<cword>')
    if match(cword, search) == -1
        exe printf('match WordUnderCursor /\V\<%s\>/', escape(cword, '/\'))
    endif
endfunction


" https://unix.stackexchange.com/questions/199203/why-does-vim-indent-pasted-code-incorrectly
augroup auto_comment
    au!
    au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

