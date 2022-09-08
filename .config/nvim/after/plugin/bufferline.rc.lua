local status, bufferline = pcall(require, 'bufferline')
if (not status) then return end

bufferline.setup({
  options = {
    mode = 'tabs',
    separator_style = 'padded_slant',
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true
  },
  highlights = {
    separator = {
      fg = '#1f2329',
      bg = '#181b20',
    },
    separator_selected = {
      fg = '#1f2329',
    },
    background = {
      fg = '#7a818e',
      bg = '#181b20'
    },
    buffer_selected = {
      fg = '#a0a8b7',
      bold = true,
    },
    fill = {
      bg = '#0e1013'
    }
  },
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
