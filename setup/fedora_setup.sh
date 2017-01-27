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
echo "#            Dotfiles installation script for Fedora          #"
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

# Install RPM Fustion
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
     gnome-shell-extension-alternate-tab \
     gnome-shell-extension-openweather.noarch \
     gnome-shell-extension-auto-move-windows \
     gnome-shell-extension-background-logo \
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
     go \
     terminator \
     pgadmin3 \
     irssi \
     htop \
     sysstat \
     dstat \
     nmap \
     wireshark.x86_64 \
     wireshark-gnome \
     libvirt-wireshark \
     glances \
     transmission \
     filezilla \
     lftp \
     calibre \
     gconf-editor \
     dconf-editor

# Install Vagrant
echo "Installing Vagrant"
sudo dnf install -y @vagrant

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

# Install Docker
echo "Installing Docker"
sudo dnf install -y docker
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Install OpenStack client
echo "Installing OpenStack and Kubernetes clients"
sudo dnf install -y python-openstackclient kubernetes-client

## Intall themes and eye-candy

# Installing theme engines
sudo dnf install -y gtk-murrine-engine

# Install Themes
echo "Installing themes"
echo ""
mkdir $HOME/.themes
git clone https://github.com/zagortenay333/ciliora-tertia-shell.git $HOME/Downloads/ciliora-tertia-shell
mv $HOME/Downloads/ciliora-tertia-shell/Ciliora-Tertia/ $HOME/.themes/

#echo "Download latest MosCloud theme from http://dasnoopy.deviantart.com/ and install it to $HOME/.themes"
#read -p "Press any key when ready..."

# Install Numix icons
#echo "Installing Numix icons"
#sudo dnf copr enable -y numix/numix
#sudo dnf install -y numix-icon-theme numix-icon-theme-circle

# Install Fedy
echo "Fedy installation"
curl -o $HOME/Downloads/fedy-installer http://folkswithhats.org/fedy-installer
chmod +x $HOME/Downloads/fedy-installer
sudo $HOME/Downloads/fedy-installer
read -p "Launch Fedy, make the appropiate changes and press any key to continue the setup..."

# Install better fonts
read -p "Do you want to install Infinality Ultimate font rendering? [yn]" answer
if [[ $answer = y ]]; then
  echo "Infinality Ultimate setup"
  sudo dnf install -y freetype-freeworld
  sudo dnf install -y http://rpm.danielrenninghoff.com/infinality/fedora/$(rpm -E %fedora)/noarch/infinality-ultimate-repo-$(rpm -E %fedora)-1.noarch.rpm
  sudo dnf install --allowerasing -y cairo-infinality-ultimate \
      fontconfig-infinality-ultimate \
      freetype-infinality-ultimate
  sudo cp /usr/share/doc/freetype-infinality-ultimate/infinality-settings.sh /etc/X11/xinit/xinitrc.d/infinality-settings.sh
#  sudo echo "export INFINALITY_FT="osx"" >> /etc/X11/xinit/xinitrc.d/infinality-settings.sh
elif [[ $answer = n ]]; then
  echo "Infinality Ultimate not installed. Use Fedy to get a better font rendering."
fi

echo "Install Hack font"
sudo dnf copr enable -y heliocastro/hack-fonts
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

# Install Albert
echo "Installing Albert"
sudo dnf -y copr enable rabiny/albert
sudo dnf -y install albert

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
sudo dnf install -y --nogpgcheck slack

# Install Atom
echo "Installing Atom."
curl -o $HOME/Downloads/atom.x86_64.rpm -L https://atom.io/download/rpm
sudo dnf install -y $HOME/Downloads/atom.x86_64.rpm

echo "Installing Atom packages"
apm install file-icons language-terraform language-puppet idle-theme github-syntax language-awk autocomplete-awk spacegray-light-neue-ui wombat-dark-syntax

# Install Spotify desktop client
echo "Spotify installation"
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
sudo dnf install -y spotify-client

# Bash-it setup
echo "Bash-it install and configuration"
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
$HOME/.bash_it/install.sh --interactive

mkdir -p $HOME/.bash_it/custom/aliases
mkdir -p $HOME/.bash_it/custom/themes/modern-jmr
cp $dotfiles/bash_it/custom.fedora-aliases.bash $HOME/.bash_it/custom/custom.aliases.bash
cp $dotfiles/bash_it/modern-jmr.theme.bash $HOME/.bash_it/custom/themes/modern-jmr/modern-jmr.theme.bash

# Configure IRSSI
echo "irssi configuration"
mkdir -p $HOME/.irssi/scripts/autorun
curl -o $HOME/.irssi/scripts/autorun/nicklist.pl https://raw.githubusercontent.com/irssi/scripts.irssi.org/gh-pages/scripts/nicklist.pl
curl -o $HOME/.irssi/scripts/autorun/adv_windowlist.pl https://raw.githubusercontent.com/irssi/scripts.irssi.org/gh-pages/scripts/adv_windowlist.pl
curl -o $HOME/.irssi/scripts/autorun/hilightwin.pl https://raw.githubusercontent.com/irssi/scripts.irssi.org/gh-pages/scripts/hilightwin.pl
curl -o $HOME/.irssi/weed.theme https://raw.githubusercontent.com/ronilaukkarinen/weed/master/weed.theme
ln -s $dotfiles/irssi/config $HOME/.irssi/config

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
