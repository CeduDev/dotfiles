#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

function print_success() {
    echo -e "${GREEN}=========================\n\tSuccess!\n=========================\n${NC}"
}

# Ask simple y/n (Bash compatible)
function ask_yes_or_no() {
    local prompt="$1 (y/n): "
    while true; do
        # Read from /dev/tty to allow usage inside pipes (e.g. find | while read)
        read -p "$prompt" -n 1 -r REPLY < /dev/tty
        echo "" # new line
        case $REPLY in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Ask which system the user is on
function ask_system() {
    # Print prompt to stderr so it's visible when capturing stdout
    echo -e "${BLUE}What system are you using (home = h, work = w, laptop = l, server = s)?${NC}" >&2
    read -r resp < /dev/tty
    echo "${resp,,}" # lowercase
}

function new_line() {
    echo -e ""
}

function install_prerequisites() {
    echo -e "${BLUE}Checking and installing prerequisites...${NC}"

    # Check for apt (Debian/Ubuntu)
    if command -v apt-get &> /dev/null; then
        echo "Updating package list..."
        sudo apt-get update
        
        echo "Installing core tools (git, zsh, curl, unzip, fontconfig)..."
        sudo apt-get install -y git zsh curl unzip fontconfig fzf
        
        # Install eza (modern replacement for exa)
        if ! command -v eza &> /dev/null; then
             echo "Installing eza (exa replacement)..."
             sudo apt-get install -y gpg
             sudo mkdir -p /etc/apt/keyrings
             wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
             echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
             sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
             sudo apt-get update
             sudo apt-get install -y eza
        fi

    elif command -v pacman &> /dev/null; then
        # Arch Linux support (just in case)
        sudo pacman -Syu --noconfirm git zsh curl unzip fontconfig fzf eza zoxide starship
    fi

    # Install Starship (Cross-platform)
    if ! command -v starship &> /dev/null; then
        echo "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Install Zoxide (Cross-platform)
    if ! command -v zoxide &> /dev/null; then
        echo "Installing Zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
    
    # Change default shell to zsh if not already
    current_shell=$(basename "$SHELL")
    target_shell=$(which zsh)
    
    if [ "$current_shell" != "zsh" ] && [ "$SHELL" != "$target_shell" ]; then
        echo -e "${PURPLE}Changing default shell to zsh...${NC}"
        # Use sudo chsh to avoid password prompt if user has sudo NOPASSWD, 
        # or at least handle it cleanly. Passing username explicitly is safer.
        sudo chsh -s "$target_shell" "$USER"
        echo "Shell changed to $target_shell. Log out and back in to apply."
    else
        echo "Default shell is already zsh."
    fi

    print_success
}

# --- Main Script ---

echo -e "${BLUE}Welcome to the system install script!${NC}\n"

# 0. Install Prerequisites
echo -e "${BLUE}Do you want to install prerequisites (zsh, starship, zoxide, fzf, fonts, etc.)?${NC}"
if ask_yes_or_no ""; then
    install_prerequisites
fi

# 1. System Selection & Zshrc Linking
# Ask for system and assign symolink for .zshrc and path to it
system=$(ask_system)
new_line

case $system in
    h)
        echo -e "Creating .zshrc symlink for home"
        ln -sf "$HOME/dotfiles/home/.zshrc" ~/.zshrc
        SH="${HOME}/dotfiles/home/.zshrc"
        ;;
    w)
        echo -e "Creating .zshrc symlink for work"
        ln -sf "$HOME/dotfiles/work/.zshrc" ~/.zshrc
        SH="${HOME}/dotfiles/work/.zshrc"
        ;;
    l)
        echo -e "Creating .zshrc symlink for laptop"
        ln -sf "$HOME/dotfiles/laptop/.zshrc" ~/.zshrc
        SH="${HOME}/dotfiles/laptop/.zshrc"
        ;;
    s)
        echo -e "Creating .zshrc symlink for server (crab)"
        ln -sf "$HOME/dotfiles/crab/.zshrc" ~/.zshrc
        SH="${HOME}/dotfiles/crab/.zshrc"
        ;;
    *)
        echo -e "Remember to create your own .zshrc file in your home directory!"
        SH="${HOME}/.zshrc"
        ;;
esac

print_success

# 2. Font Installation
# Make the dir only if it doesn't exist
sudo mkdir -p /usr/share/fonts/TTF

# Ask if the user wants to install the font
if [ ! -f "$HOME/dotfiles/root/usr/share/fonts/TTF/Lilex.zip" ]; then 
    echo -e "${RED}Lilex.zip not found! Install from here: https://www.nerdfonts.com/${NC}" >&2
elif find "/usr/share/fonts/TTF" -type f -name 'Lilex*' | grep -q .; then
    echo -e "Font is already extracted, running fc-cache -f"
    if ! command -v fc-cache &> /dev/null; then
        echo "Installing fontconfig..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y fontconfig
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm fontconfig
        fi
    fi
    fc-cache -f
    print_success
else
    echo -e "${BLUE}Do you want to install the Lilex font?${NC}"
    if ask_yes_or_no ""; then
        # Check/Install dependency
        if ! command -v fc-cache &> /dev/null; then
            echo "Installing fontconfig..."
            if command -v apt-get &> /dev/null; then
                sudo apt-get install -y fontconfig
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm fontconfig
            fi
        fi

        dest="/usr/share/fonts/TTF"
        sudo mkdir -p "$dest"
        
        # Use temp dir to avoid wildcard expansion issues with sudo
        temp_dir=$(mktemp -d)
        echo "Extracting Lilex.zip..."
        
        # Assuming unzip is installed by prereqs or already present
        if unzip -q "$HOME/dotfiles/root/usr/share/fonts/TTF/Lilex.zip" -x "README.md" -j -d "$temp_dir"; then
            sudo mv "$temp_dir"/* "$dest/"
            rm -rf "$temp_dir"
            fc-cache -f
            print_success
        else
            echo -e "${RED}Unzip failed! Check if unzip is installed or zip is valid.${NC}" >&2
            rm -rf "$temp_dir"
        fi
    fi
fi

# 3. Source Scripts
# Ask which files should be sourced
echo -e "${BLUE}Do you want $SH to source:"
for file in common_scripts/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        new_line
        if ask_yes_or_no "$filename?"; then
            if grep -Fxq "source $(realpath "$file")" "$SH"; then
                echo -e "\n${PURPLE}Already exists, no need to source${BLUE}"
            else
                echo "source $(realpath "$file")" >> "$SH"
            fi
        fi
    fi
done

new_line
print_success

# 4. Config Symlinks
# Ask which config files to create symlinks for
echo -e "${BLUE}Do you want to create symlink for:"
find .config -type f | while read -r file; do
    new_line
    if ask_yes_or_no "$file?"; then
        if [ -L ~/"$file" ]; then
            echo -e "\n${PURPLE}Already symlinked, skipping${BLUE}"
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
    fi
done

# 5. Root Dotfiles Symlinks
# Ask which common root dotfiles to create symlinks for
# Note: bash glob handling for hidden files needs dotglob or explicit listing
shopt -s dotglob
for file in .root_dotfiles/.[^.]*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        new_line
        if ask_yes_or_no "$filename?"; then
            if [ -L ~/"$filename" ]; then
                echo -e "\n${PURPLE}Already symlinked, skipping${BLUE}"
            else
                ln -sf "$(realpath "$file")" ~/"$filename"
            fi
        fi
    fi
done
shopt -u dotglob

new_line
print_success

echo -e "${GREEN}Install script run successfully, enjoy your new system!${NC}"
