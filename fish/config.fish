if status is-interactive
    # starship init fish | source
end

# 添加 Homebrew 到 PATH
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

set -g __conda_prompt_modifier ""
function fish_conda_prompt
    return 0
end

# alias
alias ls eza
alias lt "eza -T"
alias la "eza -A"
alias ll "eza -l"

if command -qv nvim
    alias vim nvim
    alias vi nvim
end
set -gx EDITOR nvim

# Disable system information on terminal startup
function fish_greeting
end

# Surge Proxy
set -x https_proxy http://127.0.0.1:6152
set -x http_proxy http://127.0.0.1:6152
set -x all_proxy socks5://127.0.0.1:6153

# Active Undercurl
set -x TERM xterm-256color
if test -n "$TMUX"
    set -x TERM screen-256color
end

# Set java version
set -gx JAVA_HOME (/usr/libexec/java_home -v 23)

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME /Users/zhijie/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# AI APIKEY SETTING
set -x GEMINI_API_KEY AIzaSyDITFUKYJR1WQ2b9bDzIgY_4xwH9Yg2d9k
# Claude Code
set -gx ANTHROPIC_API_KEY sk-9fOCeAUCZjfd1zMFF58f781390Db4053A4C8A95c8d1028Bd
set -gx ANTHROPIC_BASE_URL "https://aihubmix.com"
# AIhubmix Claude Code
set -gx AIHUBMIX_API_KEY sk-9fOCeAUCZjfd1zMFF58f781390Db4053A4C8A95c8d1028Bd

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/zhijie/.lmstudio/bin
# End of LM Studio CLI section
