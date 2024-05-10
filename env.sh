#!/bin/sh

current_dir="$(cd "$(dirname "$0")" && pwd)"
usr="user"
pkgs="git vim tmux htop curl wget neofetch nnn ncdu zsh zoxide neovim stow"
sshd_config="/etc/ssh/sshd_config"
configure_user_script="$current_dir/user.sh"

set_config() {
  param=$1
  value=$2
  # Use sed to change the setting
  sed -i "s/^\($param\s*\).*\$/\1$value/" "$sshd_config"
  # If sed made no change (parameter was not found), append parameter
  if ! grep -q "^$param $value$" "$sshd_config"; then
    echo "$param $value" >> "$sshd_config"
  fi
}

# Define a function to check if a file exists
fd_exists() {
    if [ -e "$1" ]; then
        return 0  # 0 is success in shell scripting
    else
        return 1  # Non-zero return value indicates an error condition
    fi
}
