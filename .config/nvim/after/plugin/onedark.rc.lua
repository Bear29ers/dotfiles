local status, onedark = pcall(require, 'onedark')
if (not status) then return end

onedark.setup {
  style = 'darker',
  transparent = true,

  code_style = {
    comments = 'italic'
  },

  colors = {},
  highlights = {}
}

onedark.load()
