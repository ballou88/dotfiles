FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$HOME/.luarocks/bin:$PATH"

export EDITOR='nvim'

PATH="/Users/robertballou/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/robertballou/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/robertballou/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/robertballou/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/robertballou/perl5"; export PERL_MM_OPT;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source "$HOME/.cargo/env"

# zoxide
# alias cd="z"
# alias cdi="zi"

# bat a better cat
alias cat="bat"

# eza a better ls 
# alias ls="eza --color=always --long --git --no-user --icons=always --no-permissions --no-time --no-filesize"

# Git aliases
alias g="git"
alias gst="git status -s"
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gco="git checkout"
alias gp="git push"
alias gl="git pull"
alias glg="git log --graph --oneline --all"
alias gcm="git commit -m"
alias gaa="git add -A"

# Custom Neovims aliases
alias v='nvim'
alias vk='NVIM_APPNAME=nvim-kickstart nvim'
source <(fzf --zsh)
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
# . /opt/homebrew/opt/asdf/libexec/asdf.sh
eval "$(zoxide init zsh)"
bindkey -e

# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:$HOME/go/bin
export PATH="/opt/homebrew/bin:$PATH"
