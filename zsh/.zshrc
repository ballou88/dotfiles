source ~/.config/zsh/shell
source ~/.config/zsh/aliases
source ~/.config/zsh/functions
source ~/.config/zsh/prompt
source ~/.config/zsh/init
source ~/.config/zsh/envs
if [[ "$OSTYPE" == "darwin"* ]]; then
  source ~/.config/zsh/macos
fi

# source "$HOME/.cargo/env"
#
# # Initialize completion system if not already done
# autoload -Uz compinit && compinit
#
# # source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# # source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# export PATH=$PATH:$HOME/go/bin
# export PATH="/opt/homebrew/bin:$PATH"
# export PATH="/usr/local/bin:$PATH"
#
# export FPATH="/opt/homebrew/bin/eza/completions/zsh:$FPATH"
#
# export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
#
# alias claude="/Users/robertballou/.claude/local/claude"
#
# # bun completions
# [ -s "/Users/robertballou/.bun/_bun" ] && source "/Users/robertballou/.bun/_bun"
#
# # bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
# export PATH="$HOME/.claude/local/node_modules/.bin:$PATH"
#
# # bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
#
