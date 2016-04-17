#!/bin/bash
#
# Setup script for Fedora 23 Workstation
#
# Written by Juan Manuel Rey
# Github: https://github.com/jreypo
# Blog: http://blog.jreypo.io
#

dotfiles=$HOME/.dotfiles

# Configure SELinux
echo "SELinux setup"
sudo setenforce 0
sudo cp /etc/selinux/config /etc/selinux/config.orig
sudo sed -i s/SELINUX\=enforcing/SELINUX\=permissive/ /etc/selinux/config

# Update the system
echo "Updating the system"
sudo dnf -y update

# Install RPM Fustion
echo "Enabling RPM Fusion repository"
sudo dnf install -y –nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install codecs and VLC
echo "Installing VLC and multimedia codecs"
sudo dnf -y install gstreamer1-libav \
     gstreamer1-plugins-bad-free-extras \
     gstreamer1-plugins-bad-freeworld \
     gstreamer1-plugsins-base-tools \
     gstreamer1-plugins-good-extras \
     gstreamer1-plugins-ugly \
     gstreamer1-plugins-bad-free \
     gstreamer1-plugins-good \
     gstreamer1-plugins-base
sudo dnf install -y vlc

# Install packages
echo "General packages installation"
sudo dnf install -y gnome-shell-extension-user-theme.noarch \
     gnome-shell-extension-alternate-tab \
     gnome-shell-extension-openweather.noarch \
     gnome-shell-extension-auto-move-windows \
     gnome-tweak-tool \
     ruby \
     powerline \
     tmux \
     tmux-powerline \
     vim \
     vim-go \
     vim-powerline \
     git-review \
     python-virtualenv \
     python-pip \
     irssi \
     htop \
     sysstat \
     dstat \
     nmap \
     wireshark.x86_64 \
     wireshark-gnome \
     libvirt-wireshark \
     glances \
     gconf-editor \
     dconf-editor

# Install Vagrant
echo "Installing Vagrant"
sudo dnf install -y @vagrant
sudo dnf install -y vagrant-libvirt

# Configure libvirt
echo "Configuring libvirt"
sudo systemctl enable libvirtd
sudo gpasswd -a ${USER} libvirt
sudo newgrp libvirt

echo "Installing Virt-builder"
sudo dnf install -y libguestfs-tools-c

# Install Docker
echo "Installing Docker"
sudo dnf install -y docker
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Install OpenStack client
echo "Installing OpenStack clients"
sudo dnf install -y python-openstackclient

## Intall themes and eye-candy

# Installing theme engines
sudo dnf install -y gtk-murrine-engine

# Install MosCloud theme
echo "Download latest MosCloud theme from http://dasnoopy.deviantart.com/ and install it to $HOME/.themes"
read -p "Press any key when ready..."

# Install Fedy
echo "Fedy installation"
curl -o $HOME/Downloads/fedy-installer http://folkswithhats.org/fedy-installer
chmod +x $HOME/Downloads/fedy-installer
sudo $HOME/Downloads/fedy-installer
read -p "Launch Fedy, make the appropiate changes and press any key to continue the setup..."

# Install Albert launcher
echo "Installing Albert launcher"
sudo dnf copr enable rabiny/albert
sudo dnf install -y albert

# Install Numix icons
echo "Installing Numix icons"
sudo dnf copr enable numix/numix
sudo dnf install -y numix-icon-theme-circle

# Install better fonts
read -p "Do you want to install Infinality Ultimate font rendering? [yn]" answer
if [[ $answer = y ]]; then
  echo "Infinality Ultimate setup"
  sudo dnf install -y freetype-freeworld
  sudo dnf copr enable dnlrn/infinality-ultimate
  sudo dnf install --allowerase -y cairo-infinality-ultimate \
      fontconfig-infinality-ultimate \
      freetype-infinality-ultimate
elif [[ $answer = n ]]; then
  echo "Infinality Ultimate not installed. Use Fedy to get a better font rendering."
fi

echo "Install Hack font"
sudo dnf copr enable heliocastro/hack-fonts
sudo dnf install -y hack-fonts

# Install Google Chrome
echo "Installing Google Chrome"
sudo curl -o $HOME/Downloads/linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub
sudo rpm --import $HOME/Downloads/linux_signing_key.pub
sudo sh -c 'echo "[google-chrome]
name=Google Chrome 64-bit
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64" >> /etc/yum.repos.d/google-chrome.repo'
sudo dnf install -y google-chrome-stable

# Install Slack
echo "Slack installation"
sudo sh -c 'echo "[slack]
name=slack
baseurl=https://packagecloud.io/slacktechnologies/slack/fedora/21/x86_64
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt" >> /etc/yum.repos.d/slack.repo'
sudo dnf install -y slack

# Install Atom
echo "Installing Atom."
curl -o $HOME/Downloads/atom.x86_64.rpm -L https://atom.io/download/rpm
sudo dnf install -y $HOME/Downloads/atom.x86_64.rpm

echo "Installing Atom packages"
apm install file-icons monokai language-terraform language-puppet idle-theme github-syntax language-awk autocomplete-awk

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
ln -s $dotfiles/vim/vimrc $HOME/.vimrc
ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -s $dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $dotfiles/git/gitignore_global $HOME/.gitignore_global

## Configuration done

echo "Done. Please use Gnome Tweak-Tool to adjust your settings and restart in order for all the changes to take effect."