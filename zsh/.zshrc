alias v=nvim
alias vi=nvim
alias vim=nvim
alias l="ls -al"
alias ll="ls -al"

# use pixi
export PATH="/Users/tntokum/.pixi/bin:$PATH"

# use lscolors
export CLICOLOR=1

# zoxide
eval "$(zoxide init zsh)"

export EDITOR=nvim

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
