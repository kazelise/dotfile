if status is-interactive
    starship init fish | source
    mise activate fish | source
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
alias ls "ls -p -G"
alias lt "eza -T"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias c "ccr code"

if command -qv nvim
    alias vim nvim
    alias vi nvim
end
set -gx EDITOR nvim

# Disable system information on terminal startup
function fish_greeting
end

# Surge Proxy
# set -x https_proxy http://127.0.0.1:6152
# set -x http_proxy http://127.0.0.1:6152
# set -x all_proxy socks5://127.0.0.1:6153

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

# claude 通过 aihubmix 调用
set --export ANTHROPIC_API_KEY sk-8ChckxXf7uEgQqr13d7b64Ca33B04d2589Df2d6f2a60Ac03
set --export ANTHROPIC_BASE_URL "https://aihubmix.com"

# pnpm
set -gx PNPM_HOME /Users/zhijie/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Set Starship config based on system theme
set -l theme (~/.config/scripts/get_theme.sh)
if test "$theme" = dark
    set -x STARSHIP_CONFIG ~/.config/starship-dark.toml
else
    set -x STARSHIP_CONFIG ~/.config/starship-light.toml
end
