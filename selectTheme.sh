#!/usr/bin/env bash

trap on_ctrl_c INT

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
  DIR="$PWD";
fi

source "${DIR}/bootstrap.sh"
include lib/ansi.sh
include lib/math.sh
include lib/core.sh
include lib/ui.sh

include src/dotfiles.sh
bootstrap::finish

function main {
  

  dotfiles::select_tty_theme

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

