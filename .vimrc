"  ▌▌▌▛▛▌▛▘▛▘
"▗ ▚▘▌▌▌▌▌ ▙▖

" use vim settings instsetead of vim
set nocompatible

" Don't parse last lines for vim commands
set modelines=0

" hide buffers
set hidden

" less strict find and search
set path+=**
set ignorecase
set smartcase
set infercase
set wildignorecase
set wildignore+=.git,*.tmp,*.o,*.obj

" search highlight
set hlsearch
set incsearch

" syntax highlighting and line numbers
syntax on
set number

" better backspace handling
set backspace=indent,eol,start
set softtabstop=2

" indent 2 spaces; every 2 spaces
set shiftwidth=2
set tabstop=2

" don't replace tabs with spaces
set noexpandtab

" autoindent
set autoindent

" no line wrapping
set nowrap

" no folding
set nofoldenable

" highlight current line
set cursorline

" show non-printable characters
set list
set listchars=
set listchars+=tab:𐄙\ 
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿

" remove trailing whitespaces and ^M chars
augroup ws
  au!
  autocmd FileType c,cpp,java,php,js,json,css,scss,sass,py,rb,coffee,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
augroup end

" leader key: ,
let mapleader=","

" == c specific settings =========================================================================== 
autocmd FileType c set shiftwidth=2|set softtabstop=2|set cindent

" == custom commands =============================================================================== 
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>
