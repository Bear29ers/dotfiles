local status, indent= pcall(require, 'indent_blankline')
if (not status) then return end

indent.setup {
  show_end_of_line = true
}
