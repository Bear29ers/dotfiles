function fish_user_key_bindings
  # peco
  bind \cr peco_select_history
  bind \cf peco_change_directory

  bind \cl forward-char

  # prevent iTerm2 from closing when typing Ctrl+D
  bind \cd delete-char
end
