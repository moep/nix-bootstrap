#!/usr/bin/env bash

echo "Copying dotfiles"

dotfiles=(".bash_profile" ".gitconfig" ".inputrc" ".tmux.conf" ".vimrc" ".zshrc")

for f in ${dotfiles[@]}; do
  if [[ -L ~/{f} ]]; then
   echo "Skipping symlink for ${f}"
   continue 
  fi
  echo "${f}"
  cp "${HOME}/${f}" .
done

echo "🐟"
cp -r ${HOME}/.config/fish .

