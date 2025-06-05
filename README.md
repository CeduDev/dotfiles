# Repo for dotfiles installations

![asd](./assets/install_gif.gif)

This is the repository for my dotfiles used across my three environments: home desktop, work laptop, and personal laptop. Since each environment has different requirements (packages etc.), each environment requires it's own .zshrc-file, found it it's respective directory. Additionally, there's an install script that install the environment from scratch, given that the prequisites are completed.

This is intended for my personal use, thus, I cannot guarantee this will work for you. However, you are free to use any of the code I've created here for you own setup. If you notice any improvements or suggestions, feel free to leave an issue detailing your idea.

## Prerequisites for install script

Start by installing these in this order:

1. [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    1. NOTE! Make sure you've set the default shell to `zsh`, otherwise the install script won't work.
2. [starship](https://starship.rs/)
    1. NOTE! You need to install the Lilex font, the zip can be found under the directory [font](./font). This is handled by the install script
3. [exa](https://github.com/ogham/exa)
4. [zoxide](https://github.com/ajeetdsouza/zoxide)
5. [fzf](https://github.com/junegunn/fzf)

## Install script

The install script can be run using `./install.sh` from the root directory. It does the following (UPDATED 3.6.2025):

1. Asks the user which system they are using (home, laptop, or work, needed since these environments have different needs), and creates a symlink to the correct subfolder's .zshrc file
3. Ask the user if they want to install the Lilex font if not yet installed
4. Ask the user if they want to source each file in the directory `shell/`, and adds the source to the correct .zshrc-file if not yet sourced
5. Ask the user if they want to create a symlink for each file in the directory `config/`
6. Ask the user if they want to create a symlink for each file in the directory `common_root_dotfiles/`

Inspiration: <https://www.youtube.com/watch?v=mSXOYhfDFYo&ab_channel=BartekSpitza>
