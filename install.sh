#!/bin/zsh

# Ask Y/n for sourcing
function ask_sourcing() {
    read -q "REPLY?$1 (Y/n): " resp
    if [ -z "$resp" ]; then
        response_lc="y" # empty is Yes
    else
        response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    fi

    [ "$response_lc" = "y" ]
}

# Ask which system the user is on
function ask_system() {
    vared -p "What system are you using (home = h, work = w, laptop = l)?" -c resp
    response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    echo ${response_lc}
}

# Ask for system and assign symolink for .zshrc and path to it
system=$(ask_system)
if [[ $system == "h" ]]
then
    echo "Creating .zshrc symbolink for home"
    ln -s -f $HOME/dotfiles/home/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/home/.zshrc"
elif [[ $system == "w" ]]
then
    echo "Creating .zshrc symbolink for work"
    ln -s -f $HOME/dotfiles/work/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/work/.zshrc"
elif [[ $system == "l" ]]
then
    echo "Creating .zshrc symbolink for laptop"
    ln -s -f $HOME/dotfiles/laptop/.zshrc ~/.zshrc
    SH="${HOME}/dotfiles/laptop/.zshrc"
else
    echo "Remember to create your own .zshrc file in your home directory!"
    SH="${HOME}/.zshrc"
fi

# Ask which files should be sourced
echo "Do you want $SH to source: "
for file in shell/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask_sourcing "${filename}?"; then
		if grep -Fxq "source $(realpath "$file")" $SH
			then echo "\nAlready exists"
			else echo "source $(realpath "$file")" >> "$SH"
		fi
        fi
    fi
done

# Ask which config files to create symlinks for
echo "Do you want to create symlink for: "
for file in config/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask_sourcing "${filename}?"; then
            ln -s -f $(realpath "$file") ~/.config/$filename
        fi
    fi
done

# Ask which common root dotfiles to create symlinks for
echo "Do you want to create symlink for: "
for file in  common_root_dotfiles/.[^.]*; do
    # echo ">$i<"
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask_sourcing "${filename}?"; then
            ln -s -f $(realpath "$file") ~/$filename
        fi
    fi
done

