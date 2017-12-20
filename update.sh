#!/usr/bin/env bash

source inc/functions.sh
init_ansi

print_header "Copying dotfiles"

dotfiles=(".bash_profile" ".gitconfig" ".inputrc" ".tmux.conf" ".vimrc" ".zshrc")

for f in ${dotfiles[@]}; do
  print_bullet ${f}
  cp "${HOME}/${f}" .
done

print_bullet 🐟
cp -r ${HOME}/.config/fish .

