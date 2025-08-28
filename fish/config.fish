# ----- Starship -----
if status is-interactive
    starship init fish | source
end

# ----- Homebrew -----
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

# ----- Aliases -----
alias ls eza
alias lt "eza -T"
alias la "eza -A"
alias ll "eza -l"

if command -qv nvim
    alias vim nvim
    alias vi nvim
end
set -gx EDITOR nvim

# ----- Greeting -----
function fish_greeting
end

# ----- Terminal Colors & tmux -----
if test -n "$TMUX"
    set -gx TERM tmux-256color
else
    set -gx TERM xterm-256color
end

# ----- OrbStack -----
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# ----- bun -----
set -gx BUN_INSTALL $HOME/.bun
if not string match -q -- $BUN_INSTALL/bin $PATH
    set -gx PATH $BUN_INSTALL/bin $PATH
end

# ----- pnpm -----
set -gx PNPM_HOME $HOME/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end

# ----- API Keys （从外部文件加载）-----
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end
