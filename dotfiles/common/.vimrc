"  ▌▌▌▛▛▌▛▘▛▘
"▗ ▚▘▌▌▌▌▌ ▙▖

" use vim settings instsetead of vim
set nocompatible

" enable mouse in all modes
set mouse=a

" Status line
set ruler
set laststatus=2
hi StatusLine ctermbg=white ctermfg=240
set statusline=%f                           " file name
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y      "filetype
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag

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

" replace tabs with spaces
set expandtab

" autoindent
set autoindent

" no line wrapping
"set nowrap

" no folding
set nofoldenable

" highlight current line
set cursorline
"hi CursorLine term=bold cterm=bold guibg=White
hi CursorLine   cterm=NONE ctermbg=240 ctermfg=NONE

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

" Buftabline
nnoremap <C-Left> :bp<CR>
nnoremap <C-Right> :bn<CR>

" Fzf
nnoremap <C-P> :Files<CR>

"nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
"nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

