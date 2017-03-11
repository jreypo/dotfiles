#!/bin/bash
#
# Setup script for Ubuntu Workstation
#
# Written by Juan Manuel Rey
# Github: https://github.com/jreypo
# Blog: http://blog.jreypo.io
#

dotfiles=$HOME/.dotfiles

echo ""
echo "###############################################################"
echo "#                                                             #"
echo "#            Dotfiles installation script for Ubuntu 16.04    #"
echo "#                  Written by Juan Manuel Rey                 #"
echo "#               Github: https://github.com/jreypo             #"
echo "#                 Blog: http://blog.jreypo.io                 #"
echo "#                                                             #"
echo "###############################################################"
echo ""

# Configrue hostname
read -p "Please enter the hostname for this computer: " computername
sudo hostnamectl set-hostname $computername

# Update the system
echo "Updating the system"
sudo apt-get update && sudo apt-get upgrade -y

# Install software
echo "Installing software"
sudo apt-get install -y chrome-gnome-shell \
     vlc \
     ruby
     ruby-dev \
     build-essential \
     fonts-hack-ttf \
     fonts-hack-otf \
     vim \
     ubuntu-restricted-addons \
     ubuntu-restricted-extras \
     git-review \
     terminator

# Install GNOME GTK and icon themes
echo "Installing Numix themes"
sudo add-apt-repository -y ppa:numix/ppa
sudo apt-get update
sudo apt-get install -y numix-gtk-theme numix-icon-theme numix-icon-theme-square numix-icon-theme-circle numix-folders 

echo "Installing ARC themes"
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
sudo apt-get update
sudo apt-get install -y arc-theme

echo "Installing ARC-flatabolous themes"
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install arc-flatabulous-themed

echo "Installing Paper themes"
sudo add-apt-repository -y ppa:snwh/pulp
sudo apt-get update
sudo apt-get install -y paper-gtk-theme paper-icon-theme paper-cursor-theme

echo "Installing more themes"
sudo apt-get install -y ultra-flat-theme ultra-flat-icons
sudo git clone https://github.com/EmptyStackExn/mono-dark-flattr-icons.git /usr/share/icons/mono-dark-flattr-icons

# Install Docker
echo "Installing Docker"
sudo apt-get install -y docker.io
sudo usermod -aG docker $(whoami)

# Install Atom
echo "Installing Editor."
printf "Which code editor do you prefer, atom, vscode or none of them?"
read CODEED

case $CODEED in
     atom)
        curl -o $HOME/Downloads/atom-amd64.deb -L https://atom.io/download/deb
        sudo dpkg -i $HOME/Downloads/atom-amd64.deb
        sudo apt-get install -f
        echo "Installing Atom packages"
        apm install file-icons language-terraform language-puppet idle-theme github-syntax language-awk autocomplete-awk spacegray-light-neue-ui wombat-dark-syntax
        ;;
    vscode)
        curl -o $HOME/Downloads/code-amd64.deb -L https://go.microsoft.com/fwlink/?LinkID=760868
        sudo dpkg -i $HOME/Downloads/code-amd64.deb
        sudo apt-get install -f
        ;;
    none)
        echo "None selected, use Vim"
        ;;
esac

# Install Consolas patched font for Powerline
echo "Installing Consolas patched font"
git clone https://github.com/runsisi/consolas-font-for-powerline.git $HOME/Downloads/consolas-font-for-powerline
mkdir $HOME/.fonts
cp $HOME/Downloads/consolas-font-for-powerline/*.ttf $HOME/.fonts

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

# Install Spotify desktop client
echo "Spotify installation"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client

# Install Google Chrome
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable

## Configuration done
echo "Done. Please use Gnome Tweak-Tool to adjust your settings and restart in order for all the changes to take effect."