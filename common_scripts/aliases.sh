alias rust-repl=evcxr
alias ll="exa -l -g --icons --git"
alias lla="exa -la -g --icons --git"
alias llt="exa -1 --icons --tree --git-ignore"
alias gs='git status --short'
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"

alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto) %D%n%s%n'"
# %h  = commit hash 
# %an = author name 
# %ar = commit time 
# %D  = ref names
# %n  = new line
# %s  = commit message

alias ga='git add'
alias gc='git commit -v'
alias gb='git branch'
alias gp='git push'
alias gpl='git pull'
alias gam="git add . && git commit -v"
alias gcl="git clone"
alias gsu="git submodule update --recursive --remote"
alias pdfmd='pandoc -N -V papersize:a4 --variable "geometry=margin=0.2in"'
