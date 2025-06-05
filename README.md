# Dotfiles

> Configuration and installer for my different environments

![asd](./assets/install_gif.gif)

*Installer as of 5.6.2025*

## What is this?

Repository for my dotfiles used across my three environments: home desktop, work laptop, and personal laptop. Since each environment have different requirements (terminal behaviour, packages, plugins etc.), they require thei own .zshrc-file, found in it’s respective directory.

There’s an install script that installs the environment from scratch, given that the prequisites are completed. Additionally, common config files across my environments can be found (Git, Starship, and Tmux etc.), which are handled by the installer.

This is intended for my personal use, thus, I cannot guarantee this will work for you. However, you are free to use any of the code I've created here for you own setup. If you notice any improvements or suggestions, feel free to leave an issue detailing your idea.

## Installing

### Prerequisites for install script

Start by installing these in this order:

1. [git](https://git-scm.com/downloads)
2. [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    1. NOTE! Make sure you've set the default shell to `zsh`, otherwise the install script won't work.
3. [starship](https://starship.rs/)
    1. NOTE! You need to install the Lilex font, the zip can be found under the directory [font](./font). This is handled by the install script
4. [exa](https://github.com/ogham/exa)
5. [zoxide](https://github.com/ajeetdsouza/zoxide)
6. [fzf](https://github.com/junegunn/fzf)

### Install script

The install script can be run using `./install.sh` from the root directory. It does the following (UPDATED 3.6.2025):

1. Asks the user which system they are using (home, laptop, or work, needed since these environments have different needs), and creates a symlink to the correct subfolder's .zshrc file
3. Ask the user if they want to install the Lilex font if not yet installed
4. Ask the user if they want to source each file in the directory `common_scripts/`, and adds the source to the correct .zshrc-file if not yet sourced
5. Ask the user if they want to create a symlink for each file in the directory (and subdirectories) `.config/`
    1. If the user symlinks the files "ignore" or "template", the respective `git config --global`-command will be executed
6. Ask the user if they want to create a symlink for each file in the directory `.root_dotfiles/`

### Honorable mentions
My inspiration for this came from [this](https://www.youtube.com/watch?v=mSXOYhfDFYo&ab_channel=BartekSpitza) Youtube video.