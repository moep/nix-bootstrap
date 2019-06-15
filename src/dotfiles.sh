include lib/core.sh
include lib/is.sh
include lib/os.sh

# Should be overwritten via dotfiles/xxx.sh
function dotfiles::install_prerequisites() {
  echo
  echo "Nothing to do here."
  echo
}

function dotfiles::install_vim_plugins() {
  ui::h2 "Installing Vim plugins"
  
  echo -n "    Ctrl+P "
  # Ctrl+P
  os::exec_and_wait git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
  echo

  echo -n "    NERDTree "
  # NERDTree
  os::exec_and_wait git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
  echo 
}

function dotfiles::install_dotfile() {
  local src="dotfiles/common/$1"
  local target=$2

  if [[ -e "${target}" ]]; then
    cli::prompt_yn "Overwrite ${target}?" || return 1
  fi

  if [[ $ARG_SYMLINK == "true" ]]; then
    dotfiles::symlink_dotfile "${src}" "$2"
  else
    dotfiles::copy_dotfile "${src}" "$2"
  fi
}

function dotfiles::copy_dotfiles() {
  echo
  ui::h1 .files
  dotfiles::install_dotfile .vimrc ~/.vimrc
  dotfiles::install_dotfile .zshrc ~/.zshrc
  dotfiles::install_dotfile .tmux.conf ~/.tmux.conf
}

function dotfiles::symlink_dotfile() {
  local src=$1
  local target=$2

  echo -n "  Symlinking "; ansi::cyan; echo -n $src; ansi::reset; 
  ansi::bold; echo -n " ==> "; ansi::reset
  ansi::blue; echo -n $target; ansi::reset
  ln -s $src $target
  echo
}


function dotfiles::copy_dotfile() {
  local src=$1
  local target=$2

  echo -n "  Copying "; ansi::cyan; echo -n $src; ansi::reset; 
  ansi::bold; echo -n " ==> "; ansi::reset
  ansi::blue; echo -n $target; ansi::reset
  cp $src $target
  echo
}

# Overwrite function definition with OS specific ones
case "${__OS_ARCH}" in
  "Darwin")
    include src/dotfiles/osx.sh
    ;;
  *)
  printf "Unsupported OS."
  exit $RC_ERROR
  ;;
esac