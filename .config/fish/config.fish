if status is-interactive
  # Commands to run in interactive sessions can go here
  set PATH /opt/homebrew/bin $PATH
  set -x PATH $HOME/.anyenv/bin $PATH
  eval (anyenv init - | source)
end

# exa
if type -q exa
  alias ll "exa -l -g --icons"
  alias la "ll -a"
  alias lt "ll --tree"
end
