#!/bin/sh

DOTFILES="$HOME/dotfiles"
mkdir -p "$HOME/.config"

if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
  printf 'Skipping existing %s\n' "$HOME/.zshrc"
else
  printf 'Linking %s -> %s\n' "$HOME/.zshrc" "$DOTFILES/.zshrc"
  ln -s "$DOTFILES/.zshrc" "$HOME/.zshrc"
fi

for item in "$DOTFILES"/.config/*; do
  [ -e "$item" ] || [ -L "$item" ] || continue

  name=${item##*/}
  destination="$HOME/.config/$name"

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf 'Skipping existing %s\n' "$destination"
  else
    printf 'Linking %s -> %s\n' "$destination" "$item"
    ln -s "$item" "$destination"
  fi
done
