source $HOME/dotfiles/.zshrc_common

# Aliases
alias ls='ls --color'
alias kubectl="minikube kubectl --"

# Path variables
path+=("$HOME/.local/bin")
path+=("$HOME/.console-ninja/.bin")
. "$HOME/.cargo/env"
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cedric/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cedric/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/cedric/miniconda3/etc/profile.d/conda.sh"
    else
        path+=("/home/cedric/miniconda3/bin")
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH

# Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
source /home/cedric/dotfiles/shell/aliases.sh
source /home/cedric/dotfiles/shell/case_insensitive_completion.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /home/cedric/dotfiles/shell/ssh-alias.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/cedric/google-cloud-sdk/path.zsh.inc' ]; then . '/home/cedric/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/cedric/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/cedric/google-cloud-sdk/completion.zsh.inc'; fi
source /usr/share/nvm/init-nvm.sh
