# Set the default editor
export EDITOR=/usr/local/bin/vim

# Better history tracking for self analytics
HISTFILE=$HOME/.zsh_history
HISTSIZE=20000
SAVEHIST=20000
setopt append_history
setopt extended_history
# setopt hist_expire_dups_first
# setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# setopt share_history # share command history data

export PATH=/usr/local/bin:/usr/local/sbin:/Users/mballou/.bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

fpath=(/usr/local/share/zsh-completions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Setup zsh-autosuggestions
source ~/.zsh-autosuggestions/autosuggestions.zsh

# Aliases {{{
  alias v='vi'
  alias c='cd'
  alias zshconfig="vi ~/.zshrc"
  alias bower='noglob bower'
  alias rake='noglob rake'
  alias code='cd ~/code'
  alias flush_dns="sudo killall -HUP mDNSResponder"
  alias reload="source ~/.zshrc"
  alias be="noglob bundle exec"
  alias gst='git status -s'
  compdef _git gst=git-status
  alias gd='git diff'
  compdef _git gd=git-diff
  alias gl='git pull'
  compdef _git gl=git-pull
  alias gup='git pull --rebase'
  compdef _git gup=git-fetch
  alias gp='git push'
  compdef _git gp=git-push
  alias gd='git diff'
  gdv() { git diff -w "$@" | view - }
  compdef _git gdv=git-diff
  alias gc='git commit'
  compdef _git gc=git-commit
  alias gc!='git commit --amend'
  compdef _git gc!=git-commit
  alias gca='git commit -am'
  compdef _git gc=git-commit
  alias gca!='git commit -a --amend'
  compdef _git gca!=git-commit
  alias gco='git checkout'
  compdef _git gco=git-checkout
  alias gcm='git checkout master'
  alias gr='git remote'
  compdef _git gr=git-remote
  alias grv='git remote'
  compdef _git grv=git-remote
  alias grmv='git remote rename'
  compdef _git grmv=git-remote
  alias grrm='git remote remove'
  compdef _git grrm=git-remote
  alias grset='git remote set-url'
  compdef _git grset=git-remote
  alias grup='git remote update'
  compdef _git grset=git-remote
  alias gb='git branch'
  compdef _git gb=git-branch
  alias gba='git branch -a'
  compdef _git gba=git-branch
  alias gcount='git shortlog -sn'
  compdef gcount=git
  alias gcl='git config --list'
  alias gcp='git cherry-pick'
  compdef _git gcp=git-cherry-pick
  alias glg='git log --stat --max-count=5'
  compdef _git glg=git-log
  alias glgg='git log --graph --max-count=5'
  compdef _git glgg=git-log
  alias glgga='git log --graph --decorate --all'
  compdef _git glgga=git-log
  alias glo='git log --oneline'
  compdef _git glo=git-log
  alias gss='git status -s'
  compdef _git gss=git-status
  alias ga='git add'
  compdef _git ga=git-add
  alias gm='git merge'
  compdef _git gm=git-merge
  alias grh='git reset HEAD'
  alias grhh='git reset HEAD --hard'
  alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
  alias gf='git ls-files | grep'
  alias gpoat='git push origin --all && git push origin --tags'
  alias acurl='curl -g -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no" '
  alias vim2='vim -u ~/.vimrc2'
  alias gfd='git diff --name-only'
  alias iss='invoker start -d ~/stack.ini'
  alias irt='invoker reload tunnels'
  alias ira='invoker reload central-admin'
  alias irs='invoker reload spokeo'
  alias td='todo.sh'

  # Will cd into the top of the current repository
  # or submodule.
  alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
  alias cat="coderay"

  alias bs-tunnel='ssh -f beta-gateway.spokeo.com -L 3340:bbz-dba1:3306 -N'
# }}}

# Disable corrections
unsetopt correct_all
cd ..;cd -
source ~/.bin/tmuxinator.zsh
export TERM=xterm-256color
eval "$(rbenv init -)"

# Enable autosuggestions automatically
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^T' autosuggest-toggle
