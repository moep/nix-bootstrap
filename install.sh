#!/usr/bin/env bash

# TODO support profiles (desktop (light / normal), server)
trap on_ctrl_c INT

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
  DIR="$PWD";
fi

source "${DIR}/bootstrap.sh"
include lib/cli.sh
include lib/core.sh
include lib/os.sh
include lib/str.sh
include lib/ui.sh

include lib/osx/iterm2.sh
# Project specific include(s)
include src/dotfiles.sh
bootstrap::finish

REQUIRED_PGMS=(figlet htop netcat nmap pv screenfetch vim wakeonlan youtube-dl zsh)

declare -r K_ICON_CHECK='✓'
declare -r K_ICON_WARN='⚠'
declare -r K_ICON_FAIL='✘'

declare ARG_SYMLINK=false
declare ARG_BATCH=false

function main {
  parse_args $* || usage

  ansi::cls
  ansi::cur_pos 1 1
  ansi::cur_hide
  cat banner.txt
  ansi::reset

  if [[ $ARG_BATCH == "true" ]]; then
    function cli::prompt_yn {
      local preselection=$2
      if ! is::_ empty "${preselection}"; then
        case $preselection in
          'y'|'Y')
            return $TRUE
          ;;
          *)
            return $FALSE
          ;;
        esac
      else
        return $TRUE
      fi
    }
  fi

  echo
  ansi::bold; str::pad_right 15 "OS:"; ansi::reset; printf "%s" "$(uname -spr)"; printf "\r\n"
  ansi::bold; str::pad_right 15 "Symlink:"; ansi::reset; echo $ARG_SYMLINK
  ansi::bold; str::pad_right 15 "Batch mode:"; ansi::reset; echo $ARG_BATCH
  echo 
  
  # Theme selection
  #dotfiles::select_tty_theme
  
  # Install programms needed for this script
  ui::h1 prerequisites
  dotfiles::install_prerequisites
  
  # Install Vim Plugins
  ui::h1 plugins
  cli::prompt_yn "Install vim plugins?" y && {
    dotfiles::install_vim_plugins
    echo
  }
  
  # Install oh-my-zsh
  cli::prompt_yn "Install oh-my-zsh?" n && {
    echo -n "Installing oh-my-zsh "
    os::exec_and_wait sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo
  }

  # Copy Dotfiles
  dotfiles::copy_dotfiles  

  ansi::cur_show
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

function on_ctrl_c() {
  cleanup
  echo
  echo "Aborted."

  exit 0
}

function cleanup() {
  ansi::cur_show
  ansi::reset
  ui::enable_keyboard_input
  # Kill all child processes
  pkill -P $$

  echo
}

main $@ 

