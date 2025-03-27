# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# History
HISTSIZE=5000
HISTFILE=${HOME}/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-a}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:cd:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'

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
