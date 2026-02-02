source $HOME/dotfiles/.zshrc_common

# Aliases
alias ls='ls --color'

# Path variables
path+=("$HOME/.local/bin")
path+=("$HOME/.cargo/bin")
path+=("~/.console-ninja/.bin")
path+=("$(npm prefix -g)/bin")

export PATH

# Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source /home/crab/dotfiles/common_scripts/aliases.sh
source /home/crab/dotfiles/common_scripts/case_insensitive_completion.sh
source /home/crab/dotfiles/common_scripts/ssh-alias.sh

# OpenClaw Completion
source <(openclaw completion --shell zsh)
