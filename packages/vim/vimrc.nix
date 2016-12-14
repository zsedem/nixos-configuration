{ stdenv, writeText }:

let
    # generic     = builtins.readFile ./vimrc/general.vim;
    # textediting = builtins.readFile ./vimrc/textediting.vim;
    # plug        = import ./vimrc/pluginconfigurations.nix;
    a = "";
in

''
syntax on
filetype on
set breakindent
set breakindentopt=sbr
set colorcolumn=120
set cursorline
set expandtab
set foldlevel=99
set foldmethod=indent
set history=1000
set ignorecase
set incsearch
set list
set listchars=tab:▸▸,trail:·
set number
set ruler
set shiftwidth=4
set showbreak=↪\
set showmode
set smartcase
set softtabstop=4
set timeout
set timeoutlen=400
set title
set tw=120
set wildignore+=*\\tmp\\*,*.hi,*.swp,*.swo,*.o,*.zip,.git,.cabal-sandbox,node_modules,.stack-work
set mouse=""

imap jj <ESC>
''
