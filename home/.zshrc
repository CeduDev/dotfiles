source $HOME/dotfiles/.zshrc_common

# Aliases
alias ls='ls --color'

# Path variables
path+=("$HOME/.local/bin")
path+=("$HOME/eww/target/release/eww")
path+=("$HOME/.console-ninja/.bin")
path+=("$HOME/zig-linux-x86_64-0.13.0-dev.386+3964b2a31")
path+=("/usr/local/go/bin")
export GOPATH=$HOME/go
. "$HOME/.cargo/env"
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

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
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
source /home/cedric/dotfiles/shell/aliases.sh
source /home/cedric/dotfiles/shell/case_insensitive_completion.sh
source /home/cedric/dotfiles/shell/ssh-alias.sh

. "$HOME/.cargo/env"
