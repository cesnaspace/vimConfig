if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'tpope/vim-sensible'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'vim-airline/vim-airline'
" Initialize plugin system
call plug#end()

let mapleader = ","
set number
set nohlsearch

set listchars=tab:→\ ,nbsp:␣,trail:•,precedes:«,extends:»
set list

set statusline+=%F

nnoremap <Leader>g :grep! -sI -in --exclude-dir='.git' '<cword>' -R .
vnoremap <Leader>g "vy<Cr>:exec "grep! " getreg("v")"--exclude-dir='.git' -RIisn ."
nnoremap <silent> ) :cnext<Cr>
nnoremap <silent> ( :cprevious<Cr>
nnoremap <silent> > :bnext<Cr>
nnoremap <silent> < :bprev<Cr>
command! BW :bn|:bd#
nnoremap <silent> <Leader>w :BW<Cr>

command -nargs=* MMake :make! <q-args><bar>copen
set mouse=n
set mouse+=v
set incsearch


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

