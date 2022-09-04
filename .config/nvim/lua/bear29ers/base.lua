local opt = vim.opt

vim.cmd('autocmd!')

-- Encoding
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.shell = 'fish'

--earch
opt.hlsearch = true
opt.ignorecase = true
opt.wrapscan = true
opt.inccommand = 'split'

-- Edit
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 0
opt.smarttab = true
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.backspace = { 'start', 'eol', 'indent' }

-- Display
opt.title = true
vim.wo.number = true
opt.wrap = false
opt.laststatus = 2
opt.cmdheight = 1
opt.showcmd = true

-- Cursor
opt.scrolloff = 15

-- Files
opt.backup = false
opt.backupskip = { '/tmp/*', '/private/tmp/*' }
opt.path:append { '**' }
opt.wildignore:append { '*/node_modules/*' }

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert mode.
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste'
})

-- Don't auto commenting new lines
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  command = 'set fo-=c fo=r fo-=o',
})

-- Resotre the cursor location when file is opened
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Insert a leader in current comment automatically when it's insert mode.
opt.formatoptions:append { 'r' }
