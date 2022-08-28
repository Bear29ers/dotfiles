# Color
set -gx TERM xterm-256color

# Aliases
alias g git
command -qv nvim && alias vim nvim
command -qv nvim && alias vi nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# Homebrew
set PATH /opt/homebrew/bin $PATH

# anyenv
set -x PATH $HOME/.anyenv/bin $PATH
eval (anyenv init - | source)

# exa
if type -q exa
  alias ll "exa -l -g --icons"
  alias la "ll -a"
  alias lt "ll --tree"
end
