My dotfiles
===========

My dotfiles for Linux, Windows and macos. Includes PowerShell, Bash, tmux and VIM environment files.

Credit goes mostly to [Timo Sugliani](https://twitter.com/tsugliani) and [Fabio Raposselli](https://twitter.com/fabiorapposelli) from whom I borrowed some examples and files.

iTerm color schemes are mine and one taken from Adam Hawkins [dotfiles](https://github.com/ahawkins/dotfiles).

## Installation

Included with the repo there are two installation scripts for OSX and Fedora. This scripts are not only to install dotfiles but also to configure a newly installed system.

1. Clone the repo `git clone https://github.com/jreypo/dotfiles.git ~/.dotfiles`.
2. For macOS there are two scripts, one for my dev personal MBP and another for my work MBP, both in `setup` folder.
   1. `macos-dev-setup.sh`.
   2. `macos-work-setup.sh`.
3. For Fedora Workstation execute `fedora_setup.sh` script in folder `setup`. Outdated, needs an update for most recent Fedora versions,
4. For Windows PowerShell follow the README instructions in the `powershell` folder.
   1. There an outdated script for Windows Subsystem for Linux, `wsl_setup.sh`, using Ubuntu distro.

Feel free to use and adapt any of those setup scripts for your personal purposes.

## TODO

- Add bootstrap script for servers (CentOS, RHEL, Fedora)
- Add dotfiles and bootstrap script for Debian
