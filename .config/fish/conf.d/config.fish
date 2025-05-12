#if status is-interactives

# rbenv設定
set -Ux RBENV_ROOT $HOME/.rbenv
set -U fish_user_paths $RBENV_ROOT/bin $fish_user_paths

# rbenv init
status is-interactive; and source (rbenv init -|psub)
