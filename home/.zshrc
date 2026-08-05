source $HOME/dotfiles/.zshrc_common

# Aliases
alias ls='ls --color'

# Path variables etc
path+=("$HOME/.local/bin")
path+=("$HOME/.console-ninja/.bin")

export GOPATH=$HOME/go
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))

. "$HOME/.cargo/env"

export PATH

# Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# eval "$(fzf --zsh)"
source <(fzf --zsh)
source /home/cedric/dotfiles/common_scripts/aliases.sh
source /home/cedric/dotfiles/common_scripts/case_insensitive_completion.sh
source /home/cedric/dotfiles/common_scripts/ssh-alias.sh
