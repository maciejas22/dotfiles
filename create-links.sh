#!/bin/sh

for item in "$HOME"/dotfiles/.config/*; do
  ln -s "$item" "$HOME/.config/"
done
