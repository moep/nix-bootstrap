#!/usr/bin/env bash
function init_ansi() {
  esc="\e["
  reset="${esc}0m"  
 
  bold="${esc}1m"  
 
  red="${esc}31m"
}

function print_header() {
  echo -e "${bold}>>>${reset} ${@}"
}

function print_bullet() {
  echo -e " [*] ${@}"
}

function print_color_example() {
  pcs() { for i in {0..7}; do echo -en "\e[${1}$((30+$i))m \u2588\u2588 \e[0m"; done; }
  printf "\n%s\n%s\n\n" "$(pcs)" "$(pcs '1;')"
}

function switch_theme() {
  echo -ne "\e]4;4;#ff0000\a"
}

switch_theme
print_color_example
