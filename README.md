My dotfiles
===========

My dotfiles for Linux, Windows and macOS. Includes PowerShell, Bash, tmux and VIM environment files.

Credit goes mostly to [Timo Sugliani](https://twitter.com/tsugliani) and [Fabio Raposselli](https://twitter.com/fabiorapposelli) from whom I borrowed some examples and files.

iTerm color schemes are mine and one taken from Adam Hawkins [dotfiles](https://github.com/ahawkins/dotfiles).

## Installation

Included with the repo there are installation scripts for macOS, Fedora, and WSL. These scripts are not only to install dotfiles but also to configure a newly installed system.

1. Clone the repo `git clone https://github.com/jreypo/dotfiles.git ~/.dotfiles`.
2. For macOS run `setup/macos-setup.sh`. This unified script auto-detects Intel and Apple Silicon Macs and offers a profile selection for work or personal/dev installations.
3. For Fedora Workstation execute `setup/fedora_setup.sh`. This script is outdated and not tested with the most recent Fedora versions.
4. For WSL execute `setup/wsl_setup.sh`.
5. For Windows PowerShell follow the README instructions in the `powershell` folder.

## TODO

- Add bootstrap script for servers (CentOS/Almalinux, Debian/Ubuntu Server, Fedora)
