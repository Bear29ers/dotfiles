local status, colors = pcall(require, 'lsp-colors')
if (not status) then return end

colors.setup {
  Error = '#e55561',
  Warning = '#e2b86b',
  Information = '#48b0bd',
  Hint = '#8ebd6b'
}
