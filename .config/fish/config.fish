# ===== Color / TERM =====
set -gx TERM xterm-256color

# ===== Editor =====
set -gx EDITOR nvim

# ===== PATH =====
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $HOME/bin $HOME/.local/bin $PATH

# ===== Aliases =====
alias g git
command -qv nvim && alias vim nvim
alias vi nvim
alias ws 'open -a webstorm'
alias dd 'open -a docker'
alias c clear
alias now 'date "+%Y-%m-%d %H:%M:%S"'

# eza
if type -q eza
    alias ll 'eza -l -g --icons'
    alias la 'll -a'
    alias lt 'll --tree'
    alias lat 'la --tree'
end

# Docker Aliases
source ~/.config/fish/docker.fish

# ===== anyenv =====
set -gx PATH $HOME/.anyenv/bin $PATH
if status is-interactive
    anyenv init - | source
end

# ===== rbenv =====
set -gx RBENV_ROOT $HOME/.rbenv
set -gx RUBY_LSP_PATH $HOME/.rbenv/shims/ruby-lsp

# ===== Tools =====
set -gx COPILOT_PAID_PLAN false
set -gx DISABLE_NON_ESSENTIAL_MODEL_CALLS 1
