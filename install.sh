#!/bin/bash

# Ask Y/n
function ask() {
    read -p "$1 (Y/n): " resp
    if [ -z "$resp" ]; then
        response_lc="y" # empty is Yes
    else
        response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    fi

    [ "$response_lc" = "y" ]
}

# Check what shell is being used
SH="${HOME}/.bashrc"
ZSHRC="${HOME}/.zshrc"
if [ -f "$ZSHRC" ]; then
	SH="$ZSHRC"
fi

# Ask which files should be sourced
echo "Do you want $SH to source: "
for file in shell/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask "${filename}?"; then
		if grep -Fxq "source $(realpath "$file")" $SH
			then echo "Already exists"
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
	if ask "${filename}?"; then
		ln -s -f $(realpath "$file") ~/.config/$filename
	fi
    fi
done
