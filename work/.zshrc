source $HOME/dotfiles/.zshrc_common
source $HOME/dotfiles/work/secrets.sh

# Path variables
path+=("$HOME/.local/bin")
path+=("$HOME/.cargo/bin")
path+=("~/.console-ninja/.bin")

export PATH

# Shell integrations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source <(fzf --zsh)
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
source /home/cedric/dotfiles/common_scripts/aliases.sh
source /home/cedric/dotfiles/common_scripts/case_insensitive_completion.sh
source /home/cedric/dotfiles/common_scripts/ssh-alias.sh

export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
export BROWSER="$HOME/chrome.exe"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pnpm
export PNPM_HOME="/home/cedric/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
