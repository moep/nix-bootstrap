#!/usr/bin/env bash

echo "Copying dotfiles from home to here"

dotfiles=(".bash_profile" ".bashrc" ".bash_aliases" ".inputrc" ".profile" ".tmux.conf" ".vimrc" ".zshrc")

for f in ${dotfiles[@]}; do
  if [[ -L ~/{f} ]]; then
    echo "Skipping symlink for ${f}"
    continue 
  fi
  echo "${f}"
  cp "${HOME}/${f}" dotfiles/common/
done

echo "🐟"
cp -r ${HOME}/.config/fish dotfiles/common/

echo ".figlet"
cp -r ${HOME}/.figlet dotfiles/common/

