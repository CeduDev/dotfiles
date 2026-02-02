source $HOME/dotfiles/.zshrc_common

# Aliases
alias ls='ls --color'

# Path variables
path+=("$HOME/.local/bin")
# path+=("$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin")
path+=("$HOME/.cargo/bin")
path+=("~/.console-ninja/.bin")

export PATH

# Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
#eval "$(jenv init -)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
source /home/cedric/dotfiles/common_scripts/aliases.sh
source /home/cedric/dotfiles/common_scripts/case_insensitive_completion.sh
source /home/cedric/dotfiles/common_scripts/ssh-alias.sh

# set DISPLAY variable to the IP automatically assigned to WSL2
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
# sudo /etc/init.d/dbus start &> /dev/null

# complete -C /usr/bin/terraform terraform

DOCKER_DISTRO="Ubuntu"
DOCKER_DIR=/mnt/wsl/shared-docker
DOCKER_SOCK="$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://$DOCKER_SOCK"

if [ ! -S "$DOCKER_SOCK" ]; then
     mkdir -pm o=,ug=rwx "$DOCKER_DIR"
     chgrp docker "$DOCKER_DIR"
     /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
fi
PATH=~/.console-ninja/.bin:$PATH


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# OpenClaw Completion
source <(openclaw completion --shell zsh)
