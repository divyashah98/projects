set ch=2		" Make command line two lines high

set mousehide		" Hide the mouse when typing text

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" My own personalisations
set autoindent
set nocompatible
set hlsearch
set ic
set autochdir
set ruler
set backspace=indent,eol,start

" size of a hard tabstop
set tabstop=4
" size of an "indent"
set shiftwidth=4
" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=4
" make "tab" insert indents instead of tabs at the beginning of a line
set smarttab
" always uses spaces instead of tab characters
set expandtab

" I like highlighting strings inside C comments
let c_comment_strings=1

" Switch on syntax highlighting if it wasn't on yet.
syntax on
au BufNewFile,BufRead *.sv,*.svh,* so ~/.vim/syntax/verilog_systemverilog.vim
au BufNewFile,BufRead *.v set ft=verilog
" Switch on search pattern highlighting.
set hlsearch
  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green, Cyan when ":lmap" mappings are active
  " Constants are not underlined but have a slightly lighter background
  "   highlight Normal guibg=grey90
  "   highlight Cursor guibg=magenta guifg=NONE
  "   highlight lCursor guibg=Cyan guifg=NONE
  "   highlight NonText guibg=grey80
  "   highlight Constant gui=NONE guibg=grey95
  "   highlight Special gui=NONE guibg=grey95
  " highlight Normal guibg=Black guifg=green
  " highlight Cursor guibg=white guifg=NONE
  " highlight lCursor guibg=orange guifg=NONE
  " highlight NonText guibg=Black
  " highlight Constant gui=NONE guibg=grey95
  " highlight Special gui=NONE guibg=grey95
colorscheme slate
set incsearch
