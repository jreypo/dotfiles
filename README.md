My dotfiles
===========

My dotfiles for Linux, Windows and OSX. Includes PowerShell, Bash, tmux and VIM environment files.

Credit goes mostly to [Timo Sugliani](https://twitter.com/tsugliani) and [Fabio Raposselli](https://twitter.com/fabiorapposelli) from whom I borrowed some examples and files.

iTerm color schemes are mine and one taken from Adam Hawkins [dotfiles](https://github.com/ahawkins/dotfiles).

## Installation

Included with the repo there are two installation scripts for OSX and Fedora. This scripts are not only to install dotfiles but also to configure a newly installed system. Tested with OSX 10.11 and Fedora 23.

1. Clone the repo `git clone https://github.com/jreypo/dotfiles.git ~/.dotfiles`.
2. For macOS there are two scripts, one to bootstrap my personal dev MacBook and a second one for my work MacBook. Feel free to use and modify them for your needs.
   1. Dev MacBook `macos_dev.sh`.
   2. Work MacBook `macos_work.sh`.
3. For Fedora Workstation execute `fedora_setup.sh` script in folder `setup`. This script is outdated, not tested with the most recent Fedora versions.
4. For Windows PowerShell follow the README instructions in the `powershell` folder.

## TODO

- Add bootstrap script for servers (CentOS/Almalinux, Debian/Ubuntu Server, Fedora)
