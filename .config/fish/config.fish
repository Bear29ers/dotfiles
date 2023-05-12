# Color
set -gx TERM xterm-256color

# Theme
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# Aliases
alias g git
command -qv nvim && alias vim nvim
alias vi nvim
alias ws 'open -a webstorm'
alias dd 'open -a docker'
alias c clear
alias gm 'gitmoji -c'

# Docker Aliases
source ~/.config/fish/docker.fish

# Editor
set -gx EDITOR nvim

# PATH
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
  alias ll 'exa -l -g --icons'
  alias la 'll -a'
  alias lt 'll --tree'
  alias lat 'la --tree'
end
