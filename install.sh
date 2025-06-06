#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

function print_success() {
    echo -e "${GREEN}Success!${NC}\n"
}

# Ask simple y/n
function ask_yes_or_no() {
    read -q "REPLY?$1 (y/n): " resp
    if [ -z "$resp" ]; then
        response_lc="y" # empty is Yes
    else
        response_lc=$(echo -e "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    fi

    [ "$response_lc" = "y" ]
}

# Ask which system the user is on
function ask_system() {
    vared -p "%F{blue}What system are you using (home = h, work = w, laptop = l)?%f" -c resp
    response_lc=$(echo -e "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    echo -e ${response_lc}
}

function new_line() {
    echo -e ""
}

echo -e "${BLUE}Welcome to the system install script!${NC}\n"


# Ask for system and assign symolink for .zshrc and path to it
system=$(ask_system)
new_line
if [[ $system == "h" ]]
then
    echo -e "Creating .zshrc symbolink for home"
    ln -s -f $HOME/dotfiles/home/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/home/.zshrc"
elif [[ $system == "w" ]]
then
    echo -e "Creating .zshrc symbolink for work"
    ln -s -f $HOME/dotfiles/work/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/work/.zshrc"
elif [[ $system == "l" ]]
then
    echo -e "Creating .zshrc symbolink for laptop"
    ln -s -f $HOME/dotfiles/laptop/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/laptop/.zshrc"
else
    echo -e "Remember to create your own .zshrc file in your home directory!"
    SH="${HOME}/.zshrc"
fi

print_success

# Ask if the user wants to install the font
if [ ! -f $HOME/dotfiles/root/usr/share/fonts/TTF/Lilex.zip ];
then 
    echo "${RED}Lilex.zip not found! Install from here: https://www.nerdfonts.com/${NC}" >&2
elif find "/usr/share/fonts/TTF" -type f -name 'Lilex*' | grep -q .; 
then
    echo -e "Font is already extracted, running fc-cache -f"
    fc-cache -f
    print_success
else
    echo -e "${BLUE}Do you want to install the Lilex font?\n${NC}"
    if ask_yes_or_no; then
        dest="/usr/share/fonts/TTF"
        unzip -qq $HOME/dotfiles/root/usr/share/fonts/TTF/Lilex.zip -x "README.md" -j -d $dest/Lilex.zip
        mv $dest/Lilex.zip/* $dest/
        rm -rf $dest/Lilex.zip
        fc-cache -f
        print_success
    fi
fi


# Ask which files should be sourced
echo -e "${BLUE}Do you want $SH to source:"
for file in common_scripts/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "${BLUE}"
        if ask_yes_or_no "${filename}?"; then
            if grep -Fxq "source $(realpath "$file")" $SH
                then echo -e "\n${PURPLE}Already exists, no need to source"
                else echo -e "source $(realpath "$file")" >> "$SH"
            fi
        fi
    fi
done

echo ""
print_success

# Ask which config files to create symlinks for
echo -e "${BLUE}Do you want to create symlink for:"
find .config -type f | while read -r file; do
    if ask_yes_or_no "$file?"; then
        echo -e ""
        dest="$HOME/$file"
        mkdir -p "$(dirname "$dest")"
        ln -sf "$(realpath "$file")" "$dest"

        # Special handling for .config/git/ignore and .config/git/template
        if [[ "$file" == ".config/git/ignore" ]]; then
            git config --global core.excludesFile "$dest"
        elif [[ "$file" == ".config/git/template" ]]; then
            git config --global commit.template "$dest"
        fi
    fi
done

echo ""
print_success

# Ask which common root dotfiles to create symlinks for
echo -e "${BLUE}Do you want to create symlink for:"
for file in  .root_dotfiles/.[^.]*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask_yes_or_no "${filename}?"; then
            ln -s -f $(realpath "$file") ~/$filename
        fi
    fi
done

echo ""
print_success

echo "${GREEN}Install script run successfully, enjoy your new system!"