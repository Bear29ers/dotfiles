local status, saga = pcall(require, 'lspsaga')
if (not status) then return end

saga.setup({})

local diagnostic = require('lspsaga.diagnostic')
local bufopts = { noremap = true, silent = true }

vim.keymap.set("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", bufopts)
vim.keymap.set("n", "sh", "<Cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", bufopts)
vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", bufopts)
vim.keymap.set("n", "gr", "<Cmd>Lspsaga rename<CR>", bufopts)
vim.keymap.set("n", "gp", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
vim.keymap.set("n", "gn", "<Cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)

-- code action
local codeaction = require('lspsaga.codeaction')

vim.keymap.set("n", "ca", function() codeaction:code_action() end, { silent = true })
vim.keymap.set("v", "ca", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-U>', true, false, true))
  codeaction:range_code_action()
end, { silent = true })
