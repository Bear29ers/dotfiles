return {
  -- add onedark
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
      transparent = true,
      code_style = {
        comments = "italic",
      },
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
