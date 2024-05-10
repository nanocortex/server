#!/bin/sh

current_dir="$(cd "$(dirname "$0")" && pwd)"
. $current_dir/env.sh

# install & update packages
sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt autoclean

for package in $packages; do
    if ! dpkg -l | grep -q "$package"; then
        echo "Installing package $package..."
        apt install -y "$package"
    else
        echo "Package '$package' already installed"
    fi
done

# install lazygit
if [ ! -f /usr/local/bin/lazygit ]; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
else
    echo "Lazygit already installed"
fi




# update .zshrc
mkdir -p ~/.config/shell
fd_exists ~/.config/shell/zsh-syntax-highlighting || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/shell/zsh-syntax-highlighting
fd_exists ~/.config/shell/zsh-autosuggestions || git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/shell/zsh-autosuggestions

# update aliases

# install lunar vim
# LV_BRANCH='release-1.3/neovim-0.9' curl -s "https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh" | bash
#
#
# install p10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k


# Copy ssh keys
mkdir -p /home/$usr/.ssh
sudo cp -R /root/.ssh /home/$usr/
sudo chown $usr:$usr -R /home/$usr/.ssh
chmod 600 /home/$usr/.ssh


# Harden SSHD config
set_config "PermitEmptyPasswords" "no"
set_config "PasswordAuthentication" "no"
set_config "ChallengeResponseAuthentication" "no"
set_config "KerberosAuthentication" "no"
set_config "GSSAPIAuthentication" "no"
set_config "X11Forwarding" "no"
set_config "AllowAgentForwarding" "no"
set_config "AllowTcpForwarding" "no"
set_config "PermitTunnel" "no"
set_config "Banner" "none"
set_config "ClientAliveInterval" "300"
set_config "ClientAliveCountMax" "2"
set_config "PermitRootLogin" "no"


sudo systemctl restart ssh.service

# Install docker
if ! dpkg -l | grep -q "docker"; then
    echo "Installing docker..."
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker $usr
else
    echo "Docker already installed"
fi



echo "Script finished!"
