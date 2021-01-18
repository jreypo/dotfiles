#!/bin/bash
#
# Setup script for Fedora 23 Workstation
#
# Written by Juan Manuel Rey
# Github: https://github.com/jreypo
# Blog: http://blog.jreypo.io
#

dotfiles=$HOME/.dotfiles

echo ""
echo "###############################################################"
echo "#                                                             #"
echo "#     Dotfiles installation script for Fedora  Workstation    #"
echo "#                  Written by Juan Manuel Rey                 #"
echo "#               Github: https://github.com/jreypo             #"
echo "#                 Blog: http://blog.jreypo.io                 #"
echo "#                                                             #"
echo "###############################################################"
echo ""

# Configrue hostname
read -p "Please enter the hostname for this computer: " computername
sudo hostnamectl set-hostname $computername

# Configure SELinux
echo "SELinux setup"
sudo setenforce 0
sudo cp /etc/selinux/config /etc/selinux/config.orig
sudo sed -i s/SELINUX\=enforcing/SELINUX\=permissive/ /etc/selinux/config

# Update the system
echo "Updating the system"
sudo dnf -y update

# Install RPM Fusion and Fedora Third Party repositories
echo "Enabling Fedora Third Party repos"
sudo dnf install -y fedora-workstation-repositories

echo "Enabling RPM Fusion repository"
sudo dnf install -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install codecs and VLC
echo "Installing VLC and multimedia codecs"
sudo dnf -y install gstreamer1-libav \
     gstreamer1-plugins-bad-free-extras \
     gstreamer1-plugins-bad-freeworld \
     gstreamer1-plugins-base-tools \
     gstreamer1-plugins-good-extras \
     gstreamer1-plugins-ugly \
     gstreamer1-plugins-bad-free \
     gstreamer1-plugins-good \
     gstreamer1-plugins-base

sudo dnf install -y vlc

# Install packages
echo "General packages installation"
sudo dnf install -y gnome-shell-extension-user-theme.noarch \
     gnome-shell-extension-openweather.noarch \
     gnome-shell-extension-auto-move-windows \
     gnome-shell-extension-background-logo \
     gnome-tweak-tool \
     ruby \
     fbreader \
     powerline \
     tmux \
     tmux-powerline \
     vim \
     vim-go \
     vim-powerline \
     git-review \
     python-virtualenv \
     python-pip \
     go \
     terminator \
     htop \
     sysstat \
     dstat \
     nmap \
     wireshark.x86_64 \
     libvirt-wireshark \
     glances \
     transmission \
     filezilla \
     lftp \
     calibre \
     gconf-editor \
     dconf-editor \
     geary \ 
     evolution-ews

# Install Vagrant
echo "Installing Vagrant"
sudo dnf install -y vagrant

# Install libvirt
echo "Install Virtualization"
read -p "Do you want to install Linux KVM native virtualization? [yn]" answer
if [[ $answer = y ]]; then
  sudo dnf -y groupinstall with-optional virtualization
  # Configure libvirt
  echo "Configuring libvirt"
  sudo systemctl enable libvirtd
  sudo gpasswd -a ${USER} libvirt
  sudo newgrp libvirt
  echo "Installing Virt-builder"
  sudo dnf install -y libguestfs-tools-c
  echo "Installin Vagrant libvirt plugin"
  sudo dnf install -y vagrant-libvirt
  sudo dnf copr enable -y dustymabe/vagrant-sshfs
  sudo dnf install -y vagrant-sshfs
elif [[ $answer = n ]]; then
  echo "Install your favorite Virtualization software through its supported method"
fi

# Install Azure CLI
echo "Installing Azure CLI"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
sudo dnf install -y azure-cli

## Intall themes and eye-candy

# Installing theme engines
sudo dnf install -y gtk-murrine-engine

echo "Install Hack font"
sudo dnf copr enable zawertun/hack-fonts
sudo dnf install -y hack-fonts

# Configure GNOME
echo "Configuring GNOME"
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar "false"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "'<Super>l'"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"

# Enable FlatHub
echo "Enablig FlatHub to install FlatPak Apps"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install Spotify
echo "Instaling Spotify"
flatpak install -y flathub com.spotify.Client

echo "Installing Slack"
flatpak install -y flathub com.slack.Slack

echo "Installing Telegram"
flatpak install -y flathub org.telegram.desktop

# Install Atom
echo "Installing Virtual Studio Code."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf check-update
sudo dnf install -y code

# Bash-it setup
echo "Bash-it install and configuration"
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
$HOME/.bash_it/install.sh --interactive

mkdir -p $HOME/.bash_it/custom/aliases
mkdir -p $HOME/.bash_it/custom/themes/modern-jmr
cp $dotfiles/bash_it/custom.fedora-aliases.bash $HOME/.bash_it/custom/custom.aliases.bash
cp $dotfiles/bash_it/modern-jmr.theme.bash $HOME/.bash_it/custom/themes/modern-jmr/modern-jmr.theme.bash

# Dotfiles setup
echo ".dotfiles setup"
mkdir -p $HOME/.vim/colors
cp $dotfiles/vim/wombat256mod.vim $HOME/.vim/colors
ln -s $dotfiles/vim/vimrc_fedora $HOME/.vimrc
ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -s $dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $dotfiles/git/gitignore_global $HOME/.gitignore_global

## Configuration done

echo "Done. Please use Gnome Tweak-Tool to adjust your settings and restart in order for all the changes to take effect."
