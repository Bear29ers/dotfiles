local status, indent = pcall(require, 'indent_blankline')
if (not status) then return end

vim.opt.listchars:append 'space:⋅'
vim.opt.listchars:append 'tab:>-'
vim.opt.listchars:append 'trail:*'
vim.opt.listchars:append 'nbsp:+'

indent.setup {
  space_char_blankline = ' ',
  show_current_context = true,
  show_current_context_start = true,
  show_end_of_line = false
}
