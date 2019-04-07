#!/bin/bash
#
# Setup script for Ubuntu GNOME 16.10
#
# Written by Juan Manuel Rey
# Github: https://github.com/jreypo
# Blog: http://blog.jreypo.io
#

dotfiles=$HOME/.dotfiles

echo ""
echo "###############################################################"
echo "#                                                             #"
echo "#            Dotfiles installation script for Windows         #"
echo "#               Subsystem for Linux with Ubuntu               #"
echo "#                  Written by Juan Manuel Rey                 #"
echo "#               Github: https://github.com/jreypo             #"
echo "#                 Blog: http://blog.jreypo.io                 #"
echo "#                                                             #"
echo "###############################################################"
echo ""

# Configrue hostname
read -p "Please enter the hostname for this computer: " computername
sudo hostname $computername
sudo echo $computername >> /etc/hostname

# Update the system
echo "Updating the system"
sudo apt-get update && sudo apt-get upgrade -y

# Install software
echo "Installing software"
sudo apt-get install -y ruby \
     ruby-dev \
     curl \
     software-properties-common \
     apt-transport-https \
     build-essential \
     vim \
     lsb_release \
     gpg \
     git-review \
     python-pip \
     tmux 

# Install Powerline
echo "Installing Powerline"
sudo pip install git+git://github.com/Lokaltog/powerline

# Install Azure CLI
echo "Installing Azure CLI"
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli -y

# Install Docker
echo "Installing Docker client"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-get update
sudo apt-get install -y docker-ce 

sudo usermod -aG docker $USER

# Install Service Fabric Client
echo "Installing Service Fabric client"
sudo apt-get install python3
sudo apt-get install python3-pip
pip3 install sfctl

# Install aditional software
echo "Installing more dev software"
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

# Dotfiles setup
echo ".dotfiles setup"
mkdir -p $HOME/.vim/colors
cp $dotfiles/vim/wombat256mod.vim $HOME/.vim/colors
ln -s $dotfiles/vim/vimrc_ubuntu $HOME/.vimrc
ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -s $dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $dotfiles/git/gitignore_global $HOME/.gitignore_global
rm -f ~/.bashrc
ln -s $dotfiles/linux/bashrc_wsl $HOME/.bashrc
ln -s $dotfiles/linux/bash_aliases_wsl $HOME/.bash_aliases
cp -f $dotfiles/linux/wsl.conf /etc/wsl.conf

## Configuration done
echo "DONE!"
