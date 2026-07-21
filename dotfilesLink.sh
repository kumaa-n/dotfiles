#!/usr/bin/env zsh

mkdir -p ~/.config
mkdir -p ~/.zsh

ln -s ~/.dotfiles/.zshenv ~/.zshenv
ln -s ~/.dotfiles/.config/git ~/.config/git
ln -s ~/.dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/.dotfiles/.config/starship.toml ~/.config/starship.toml
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.config/zsh ~/.config/zsh
ln -s ~/.dotfiles/.zsh/completion ~/.zsh/completion
