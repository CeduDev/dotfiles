#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

function print_success() {
    echo -e "${GREEN}=========================\n\tSuccess!\n=========================\n${NC}"
}

# Ask simple y/n (NOTE!!! Uses a zsh convention, if using other shells then change this)
function ask_yes_or_no() {
    read -q "REPLY?$1 (y/n): "
}

# Ask which system the user is on
function ask_system() {
    vared -p "%F{blue}What system are you using (home = h, work = w, laptop = l, server = s)?%f" -c resp
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
elif [[ $system == "s" ]]
then
    echo -e "Creating .zshrc symbolink for server (crab)"
    ln -s -f $HOME/dotfiles/crab/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/crab/.zshrc"
else
    echo -e "Remember to create your own .zshrc file in your home directory!"
    SH="${HOME}/.zshrc"
fi

print_success

# Make the dir only if it doesn't exist
sudo mkdir -p /usr/share/fonts/TTF

# Ask if the user wants to install the font
if [ ! -f "$HOME/dotfiles/root/usr/share/fonts/TTF/Lilex.zip" ]; then 
    echo "${RED}Lilex.zip not found! Install from here: https://www.nerdfonts.com/${NC}" >&2
elif find "/usr/share/fonts/TTF" -type f -name 'Lilex*' | grep -q .; then
    echo -e "Font is already extracted, running fc-cache -f"
    if ! command -v fc-cache &> /dev/null; then
        echo "Installing fontconfig..."
        sudo apt-get install -y fontconfig
    fi
    fc-cache -f
    print_success
else
    echo -e "${BLUE}Do you want to install the Lilex font?\n${NC}"
    if ask_yes_or_no; then
        # Check/Install dependency
        if ! command -v fc-cache &> /dev/null; then
            echo "Installing fontconfig..."
            sudo apt-get install -y fontconfig
        fi

        dest="/usr/share/fonts/TTF"
        sudo mkdir -p "$dest"
        
        # Use temp dir to avoid wildcard expansion issues with sudo
        temp_dir=$(mktemp -d)
        echo "Extracting Lilex.zip..."
        
        if unzip -q "$HOME/dotfiles/root/usr/share/fonts/TTF/Lilex.zip" -x "README.md" -j -d "$temp_dir"; then
            sudo mv "$temp_dir"/* "$dest/"
            rm -rf "$temp_dir"
            fc-cache -f
            print_success
        else
            echo "${RED}Unzip failed! Check if unzip is installed (sudo apt install unzip) or if the zip is valid.${NC}" >&2
            rm -rf "$temp_dir"
        fi
    fi
fi

# Ask which files should be sourced
echo -e "${BLUE}Do you want $SH to source:"
for file in common_scripts/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        new_line
        if ask_yes_or_no "${filename}?"
            then
                if grep -Fxq "source $(realpath "$file")" $SH
                    then echo "\n${PURPLE}Already exists, no need to source${BLUE}"
                    else echo -e "source $(realpath "$file")" >> "$SH"
                fi
            else new_line
        fi
    fi
done

new_line
print_success

# Ask which config files to create symlinks for
echo -e "${BLUE}Do you want to create symlink for:"
find .config -type f | while read -r file; do
    new_line
    if ask_yes_or_no "$file?"
        then
            if [ -L ~/$file ]
                then echo -e "\n${PURPLE}Already symlinked, skipping${BLUE}"
                else
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
        else echo -e "${BLUE}"
    fi
done

# Ask which common root dotfiles to create symlinks for
for file in  .root_dotfiles/.[^.]*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        new_line
        if ask_yes_or_no "${filename}?"
            then
                if [ -L ~/$filename ]
                    then echo -e "\n${PURPLE}Already symlinked, skipping${BLUE}"
                    else ln -s -f $(realpath "$file") ~/$filename
                fi
            else echo -e "${BLUE}"
        fi
    fi
done

new_line
print_success

echo "${GREEN}Install script run successfully, enjoy your new system!"
