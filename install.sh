#!/usr/bin/env bash

source bootstrap.sh
include lib/ui.sh
include lib/os.sh
include lib/str.sh
include lib/cli.sh
bootstrap::finish

REQUIRED_APPS=(figlet git htop netcat nmap screenfetch vim wakeonlan youtube-dl zsh)

declare -r K_ICON_CHECK='✓'
declare -r K_ICON_WARN='⚠'
declare -r K_ICON_FAIL='✘'

declare ARG_SYMLINK=false
declare ARG_BATCH=false

function main {
  parse_args $* || usage

  ansi::cls
  ansi::cur_pos 1 1
  cat banner.txt

  if [[ $ARG_BATCH == "true" ]]; then
    function cli::prompt_yn {
      return 0
    }
  fi

  echo
  ansi::bold; str::pad 15 "OS:"; ansi::reset; printf "%s" "$(uname -spr)"; printf "\r\n"
  ansi::bold; str::pad 15 "Symlink:"; ansi::reset; echo $ARG_SYMLINK
  ansi::bold; str::pad 15 "Batch mode:"; ansi::reset; echo $ARG_BATCH

  echo 
  ui::h1 prerequisites
  check_prerequisites
  echo

  cli::prompt_yn "Install vim plugins?" && {
    ui::h1 vim plugins
    install_vim_plugins
    echo
  }

  cli::prompt_yn "Install oh-my-zsh?" && {
    ui::h1 "oh-my-zsh"
    #sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo
  }

  echo
  ui::h1 .files
  install_dotfile .vimrc ~/.vimrc
  install_dotfile .zshrc ~/.zshrc
  install_dotfile .tmux.config ~/.tmux.conf
}

function parse_args() {
  for arg in "$@"; do
    case $arg in
      -b|--batch)
        ARG_BATCH=true
        ;;
      -s|--symlink)
        ARG_SYMLINK=true
      ;;
      *)
        usage
        return 1
    esac
  done

  return 0
}

function usage() {
  echo $(ansi::bold)"Usage: "$(ansi::reset)$(basename $0) $(ansi::white)"(args)"$(ansi::reset)
  echo "  "$(ansi::bold)"-b --batch"$(ansi::reset)"      Batch mode"
  echo "  "$(ansi::bold)"-s --symlink"$(ansi::reset)"    Symlink dotfiles instead of copying"
  echo "  "$(ansi::bold)"-? -h --help"$(ansi::reset)"    Show Help"
  exit 1
}

function check_prerequisites() {
  # Installed apps
  print_install_status brew
}

function print_install_status() {
  echo -en "  $1\r"
  os::is_installed? $1 && {
    ansi::green
    ansi::bold
    printf "%s" $K_ICON_CHECK
    ansi::reset
  } || {
    ansi::red
    ansi::bold
    printf "%s" $K_ICON_FAIL
    ansi::reset
  }

  echo -en "\r\n"
}

function install_vim_plugins() {
  # Ctrl+P
  git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim

  # NERDTree
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
}

function install_dotfile() {
  local src=$1
  local target=$2
  
  if [[ -e "${target}" ]]; then
    cli::prompt_yn "Overwrite ${target}?" || return 1
  fi

  if [[ $ARG_SYMLINK == "true" ]]; then
    symlink_dotfile $@
  else
    copy_dotfile $@
  fi
}

function symlink_dotfile() {
  local src=$1
  local target=$2

  echo -n "Symlinking "; ansi::cyan; echo -n $src; ansi::reset; 
  ansi::bold; echo -n " ==> "; ansi::reset
  ansi::blue; echo -n $target; ansi::reset
  ln -s $src $target
  echo
}


function copy_dotfile() {
  local src=$1
  local target=$2

  echo -n "Copying "; ansi::cyan; echo -n $src; ansi::reset; 
  ansi::bold; echo -n " ==> "; ansi::reset
  ansi::blue; echo -n $target; ansi::reset
  cp $src $target
  echo
}

main $@
