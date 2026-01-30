#!/usr/bin/env bash

#
# Author: Juan Manuel Rey
# Github: https://github.com/jreypo
# Blog: https://jreypo.io
#
# Unified macOS setup script for Intel and Apple Silicon Macs
#

set -e

## Initial configuration

echo ""
echo "###############################################################"
echo "#                                                             #"
echo "#         Unified dotfiles installation script for macOS      #"
echo "#                  Written by Juan Manuel Rey                 #"
echo "#               Github: https://github.com/jreypo             #"
echo "#                   Blog: https://jreypo.io                   #"
echo "#                                                             #"
echo "###############################################################"
echo ""

# Detect CPU architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    echo "Detected Apple Silicon Mac"
    HOMEBREW_PREFIX="/opt/homebrew"
else
    echo "Detected Intel Mac"
    HOMEBREW_PREFIX="/usr/local"
fi

# Ask for the administrator password upfront
sudo -v
dotfiles=$HOME/.dotfiles

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set hostname
echo -n "Please enter the hostname for this computer: "
read -r computername
sudo scutil --set ComputerName "$computername"
sudo scutil --set HostName "$computername"
sudo scutil --set LocalHostName "$computername"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$computername"

## System configuration
echo "Configuring system settings"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable in-app rating requests from apps downloaded from the App Store
defaults write com.apple.appstore InAppReviewEnabled -int 0

## Finder configuration
echo "Configuring Finder"

# Save screenshots to Screenshots folder
mkdir -p "${HOME}/Screenshots"
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
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

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

# Avoid creating .DS_Store files on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

## Dock configuration
echo "Configuring Dock and desktop"

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

## Safari configuration
echo "Configuring Safari"

# Set Safari's home page to about:blank for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Enable Safari's debug menu
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
echo "Configuring Activity Monitor"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

## Install software
echo "Proceeding to install additional software"

# Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    echo "Please complete the Xcode Command Line Tools installation and press any key to continue..."
    read -n 1 -s
fi

# Install Homebrew
echo "Installing Homebrew"
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH for the current session
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# Add Homebrew to shell profile
if [[ "$ARCH" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.bash_profile"
fi

$HOMEBREW_PREFIX/bin/brew doctor || true

read -p "Fix any brew doctor issues and press Enter when ready..."

# Install general packages
$HOMEBREW_PREFIX/bin/brew update

# Install MAS CLI
$HOMEBREW_PREFIX/bin/brew install mas

echo "Installing software with Homebrew"

# Install shell and general utilities
$HOMEBREW_PREFIX/bin/brew install bash htop coreutils wget xz watch neofetch dos2unix lftp pandoc tmux ssh-copy-id rar gpg gh openssl telnet gettext iperf3

# Install dev and sysadmin tools
$HOMEBREW_PREFIX/bin/brew install git python3 httpie nmap azure-cli

# Ask about installation profile
echo ""
echo "Select installation profile:"
echo "  1) Work (minimal)"
echo "  2) Personal/Dev (full)"
read -p "Enter choice [1-2]: " profile_choice

case $profile_choice in
    2)
        echo "Installing additional personal/dev packages..."
        $HOMEBREW_PREFIX/bin/brew install ansible rtl-sdr
        ;;
esac

# Install Kubernetes utilities
echo "Installing Kubernetes utilities"
$HOMEBREW_PREFIX/bin/brew install kubectl kubectx kubernetes-helm

# Install Powerline (for tmux and vim)
echo "Installing Powerline"
pip3 install --upgrade pip
pip3 install --user powerline-status
pip3 install --user psutil

# Install Starship prompt
echo "Installing Starship"
$HOMEBREW_PREFIX/bin/brew install starship

# Install software with Homebrew Cask
echo "Installing software with Homebrew Cask"

# Common applications for both profiles
$HOMEBREW_PREFIX/bin/brew install --cask firefox alfred cyberduck rectangle docker visual-studio-code git-credential-manager postman microsoft-edge appcleaner dotnet

case $profile_choice in
    1)
        # Work profile extras
        $HOMEBREW_PREFIX/bin/brew install --cask transmission
        ;;
    2)
        # Personal/Dev profile extras
        $HOMEBREW_PREFIX/bin/brew install --cask qbittorrent balenaetcher tunnelblick netnewswire tor-browser signal google-chrome vlc keka
        ;;
esac

# Install additional fonts (including Nerd Fonts for Starship icons)
echo "Installing additional fonts with Homebrew"
$HOMEBREW_PREFIX/bin/brew install --cask font-hack-nerd-font font-meslo-lg-nerd-font font-ubuntu-mono-derivative-powerline font-menlo-for-powerline

# Install iTerm2
echo "Installing iTerm2"
$HOMEBREW_PREFIX/bin/brew install --cask iterm2

# Install MAS software
echo "Installing software from Mac App Store"
echo "Note: You must be signed into the Mac App Store"

# Common MAS apps
$HOMEBREW_PREFIX/bin/mas install 1230249825 || true  # NepTunes
$HOMEBREW_PREFIX/bin/mas install 497799835 || true   # Xcode
$HOMEBREW_PREFIX/bin/mas install 1295203466 || true  # Microsoft Remote Desktop
$HOMEBREW_PREFIX/bin/mas install 1193539993 || true  # Brother iPrint&Scan

case $profile_choice in
    1)
        # Additional work profile MAS apps
        $HOMEBREW_PREFIX/bin/mas install 425424353 || true   # The Unarchiver
        $HOMEBREW_PREFIX/bin/mas install 1274495053 || true  # Microsoft To Do
        ;;
esac

# iTerm2 configuration
echo "Configuring iTerm2"

# Install iTerm colors
if [[ -f "${dotfiles}/iterm/ahawkins.itermcolors" ]]; then
    open "${dotfiles}/iterm/ahawkins.itermcolors"
fi

# Don't display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

## Dotfiles setup

# Set Bash as default shell
echo "Setting Bash as default shell"
BREW_BASH="$HOMEBREW_PREFIX/bin/bash"
if [[ -f "$BREW_BASH" ]]; then
    if ! grep -q "$BREW_BASH" /etc/shells; then
        echo "$BREW_BASH" | sudo tee -a /etc/shells
    fi
    chsh -s "$BREW_BASH"
fi

echo "Setting up dotfiles"
mkdir -p "$HOME/.vim/colors"
cp "$dotfiles/vim/wombat256mod.vim" "$HOME/.vim/colors/"

# Create symlinks (with backup of existing files)
for link in ".vimrc:vim/vimrc" ".tmux.conf:tmux/tmux.conf" ".gitconfig:git/gitconfig" ".gitignore_global:git/gitignore_global"; do
    target="${link%%:*}"
    source="${link##*:}"
    if [[ -e "$HOME/$target" ]] && [[ ! -L "$HOME/$target" ]]; then
        mv "$HOME/$target" "$HOME/${target}.backup"
    fi
    ln -sf "$dotfiles/$source" "$HOME/$target"
done

## Starship setup
echo "Configuring Starship prompt"

# Create starship config directory
mkdir -p "$HOME/.config"

# Symlink starship configuration
if [[ -e "$HOME/.config/starship.toml" ]] && [[ ! -L "$HOME/.config/starship.toml" ]]; then
    mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.backup"
fi
ln -sf "$dotfiles/starship/starship.toml" "$HOME/.config/starship.toml"

# Configure bash to use starship via our bashrc
# Back up existing .bashrc if it exists and is not a symlink
if [[ -e "$HOME/.bashrc" ]] && [[ ! -L "$HOME/.bashrc" ]]; then
    mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
fi
ln -sf "$dotfiles/starship/bashrc_macos" "$HOME/.bashrc"

# Source .bashrc from .bash_profile if not already configured
if ! grep -q "source.*\.bashrc" "$HOME/.bash_profile" 2>/dev/null; then
    cat >> "$HOME/.bash_profile" << 'EOF'

# Source bashrc for interactive shell settings
if [[ -f "$HOME/.bashrc" ]]; then
    source "$HOME/.bashrc"
fi
EOF
fi

## Kill affected applications
echo ""
read -p "Restart affected applications (Finder, Dock, Safari)? [y/N]: " restart_apps
if [[ "$restart_apps" =~ ^[Yy]$ ]]; then
    for app in "Finder" "Dock" "Safari"; do
        killall "$app" &>/dev/null || true
    done
fi

## Configuration done
echo ""
echo "###############################################################"
echo "#                                                             #"
echo "#                    Installation Complete!                   #"
echo "#                                                             #"
echo "###############################################################"
echo ""
echo "Please restart your Mac for all changes to take effect."
