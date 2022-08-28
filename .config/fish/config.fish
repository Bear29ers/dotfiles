if status is-interactive
    # Commands to run in interactive sessions can go here
set PATH /opt/homebrew/bin $PATH
set -x PATH $HOME/.anyenv/bin $PATH
eval (anyenv init - | source)
end
