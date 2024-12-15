#!/usr/bin/env bash

#
# Author: Juan Manuel Rey
# Github: https://github.com/jreypo
# Blog: http://blog.jreypo.io
#

# Credit: Timo Tsugliani dotfiles (https://github.com/tsugliani/dotfiles.git)
# Also highly based on ~/.osx — http://mths.be/osx

## Initial configuration

# Ask for the administrator password upfront

echo ""
echo "###############################################################"
echo "#                                                             #"
echo "#            Dotfiles installation script for work MBP        #"
echo "#                  Written by Juan Manuel Rey                 #"
echo "#               Github: https://github.com/jreypo             #"
echo "#                 Blog: http://blog.jreypo.io                 #"
echo "#                                                             #"
echo "###############################################################"
echo ""

sudo -v
dotfiles=$HOME/.dotfiles

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set hostname
echo -n "Please enter the hostname for this computer: "
read computername
sudo scutil --set ComputerName $computername
sudo scutil --set HostName $computername
sudo scutil --set LocalHostName $computername
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $computername

## System configuration
echo "Configuring system settings"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable in-app rating requests from apps downloaded from the App Store.
defaults write com.apple.appstore InAppReviewEnabled -int 0

## Finder configuration
echo "Configuring Finder"

# Save screenshots to Pictures folder
mkdir -p ${HOME}/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0.1

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Dock, Dashboard, and hot corners configuration
echo "Configuring Dock and desktop"

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

## Safari configuration
echo "Configuring Safari"

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

## TextEdit configuration
echo "Configuring TextEdit"

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

## Activity Monitor configuration
wcho "|Configuring Activity Monitor"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

## Install software
echo "Proceeding to install additional software"

# Install Homebrew
echo "Installing Homebrew"

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew doctor

read -p "Fix brew doctor issues and press any key when ready..."
# Install general packages
brew update

# Install MAS ClI
brew install mas

# Install general utilities
brew install htop coreutils wget xz watch neofetch dos2unix lftp pandoc tmux ssh-copy-id rar gpg gh openssl telnet gettext iperf3

# Install dev and sysadmin tools
brew install git python3 httpie nmap azure-cli

# Install Kubernetes utilities
echo "Installing Kubernetes utilities"
brew install kubectl kubectx kubernetes-helm

# Install Powerline
echo "Installing Powerline"
pip install --upgrade pip
pip install --user powerline-status
pip install psutil

# Install sofware with Homebrew Cask
echo "Installing software with Homebrew Cask"
brew install --cask firefox alfred cyberduck rectangle docker visual-studio-code git-credential-manager postman microsoft-edge appcleaner transmission dotnet

# Install additional fonts
echo "Installing additional fonts with Homebrew"
brew install --cask font-ubuntu-mono-derivative-powerline font-menlo-for-powerline font-hack

# Inbstall iTerm2
echo "Installing iTerm2"
brew install --cask iterm2

# Install MAS software
echo "Installing software with MAS"
mas install 1230249825
mas install 497799835
mas install 425424353
mas install 1295203466
mas install 1274495053
mas install 1193539993

# Iterm2 configuration
echo "Configuring iTerm 2"

# Install pretty iTerm colors
open "${dotfiles}/iterm/ahawkins.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

## Dotfiles setup

# Set BASH as degtault shell
echo "Setting BASH as default shell"
chsh -s /user/local/bin/bash 

echo ".dotfiles setup"
mkdir -p $HOME/.vim/colors
cp $dotfiles/vim/wombat256mod.vim $HOME/.vim/colors
ln -s $dotfiles/vim/vimrc $HOME/.vimrc
ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -s $dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $dotfiles/git/gitignore_global $HOME/.gitignore_global

## Bash-it setup
echo "Bash-it install and configuration."

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
$HOME/.bash_it/install.sh --interactive

mkdir -p $HOME/.bash_it/custom/aliases
mkdir -p $HOME/.bash_it/custom/themes/modern-jmr
ln -s $dotfiles/bash_it/custom.aliases.bash $HOME/.bash_it/custom/custom.aliases.bash
ln -s $dotfiles/bash_it/modern-jmr.theme.bash $HOME/.bash_it/custom/themes/modern-jmr/modern-jmr.theme.bash

cat >> $HOME/.bash_profile << EOF
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
EOF

## Configuration done

echo "Done. Please restart in order for all the changes to take effect."
