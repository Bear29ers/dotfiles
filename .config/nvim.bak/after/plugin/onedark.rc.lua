local status, onedark = pcall(require, 'onedark')
if (not status) then return end

local colors = require('onedark.palette')

onedark.setup {
  style = 'darker',
  transparent = true,

  code_style = {
    comments = 'italic'
  },

  colors = {},
  highlights = {
    Visual = { bg = colors.darker.light_grey }
  }
}

onedark.load()
