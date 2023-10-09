" 配色方案 "
" solarized "
"syntax enable
"set background=dark
"colorscheme solarized

" molokai "
let g:rehash256 = 1 
let g:molokai_original = 1 
highlight NonText guibg=#060606 
highlight Folded  guibg=#0A0A0A guifg=#9090D0 
set t_Co=256 
set background=dark 
colorscheme  molokai 

" 开启缩进 "
filetype plugin indent on


" 鼠标最下位置控制在倒数第七行 "
set scrolloff=7
set wildmenu
set cmdheight=2

" 智能处理退格键的功能 "
set backspace=eol,start,indent

" 忽略大小写 "
set ignorecase
set smartcase

" 显示行号 "
set number

" 高亮查找关键字 "
set hlsearch

" 查找关键字时，即时匹配 "
set incsearch

set magic
set showmatch 
set mat=2

set foldcolumn=1

set encoding=utf8

" 不自动备份文件 "
set nobackup
set nowritebackup

" 不产生交换文件(当打开一个文件未正常关闭时会产生交换文件) "
set noswapfile

" 兼容 tmux (若不设置此项，tmux 仅仅会在内容区设置背景) "
set term=screen-256color
set background=dark

" tab == 4 space "
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" autocmd FileType markdown set shiftwidth=4 tabstop=4 "

set autoindent
set smartindent
set autoread
au CursorHold,CursorHoldI * checktime

" 自动换行 "
set wrap


set switchbuf=useopen,usetab,newtab
set showtabline=2

" Return to last edit position when opening files (You want this!) "
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 显示状态栏 "
set laststatus=2

" 缩进 "
set foldmethod=syntax

" 多文件操作时，保留操作记录(可以回退) "
set undofile
set undodir=~/.vim-config/undo_dirs

" 开启剪切板 "
" set clipboard=unnamedplus

" 粘贴时不自动格式化代码 "
set noai
set paste
