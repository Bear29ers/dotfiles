local status, packer = pcall(require, 'packer')
if (not status) then
  print('Packer is not installed')
  return
end

vim.cmd[[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'navarasu/onedark.nvim' -- Colorscheme
  use 'nvim-lualine/lualine.nvim' -- Statusline

  use {
    'nvim-treesitter/nvim-treesitter', -- Treesitter
    run = function() require('nvim-treesitter.install').update { with_sync = true } end
  }

  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
end)
