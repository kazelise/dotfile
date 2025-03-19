if status is-interactive
    # macchina
    starship init fish | source
end

# 添加 Homebrew 到 PATH
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/homebrew/Caskroom/miniconda/base/bin $PATH
    end
end
# <<< conda initialize <<<
# disable conda environment prompt "cause already have starship"

set -g __conda_prompt_modifier ""
function fish_conda_prompt
    return 0
end

# alias
alias vim="nvim"
alias vi="nvim"
alias VI="vi"
alias VIM="vim"
alias ins='nvim $(fzf --preview="bat --color=always {}")'

# Disable system information on terminal startup
function fish_greeting
end

# Node version
set -gx LDFLAGS "-L/opt/homebrew/opt/node@20/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/node@20/include"

# Surge Proxy
# set -x https_proxy http://127.0.0.1:6152
# set -x http_proxy http://127.0.0.1:6152
# set -x all_proxy socks5://127.0.0.1:6153

# Active Undercurl
set -x TERM xterm-256color
if test -n "$TMUX"
    set -x TERM screen-256color
end

# Bitwarden Setting
export BW_SESSION="C5dtLlaIgANR0ssYGTDQPlCqItRU4WKCjroTnLkZAlSmEmtP+zePAYMk+L8UsJm9KYp3Wo8T6BSPxy2EHhRMdQ=="

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/william/.cache/lm-studio/bin

# Set java version
set -gx JAVA_HOME (/usr/libexec/java_home -v 23)

# Set the fuck
thefuck --alias | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
