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

  use 'nvim-lua/plenary.nvim' -- Lua Library
  use 'nvim-telescope/telescope.nvim' -- Telescope
  use 'nvim-telescope/telescope-file-browser.nvim' -- Telescope File Browser

  use 'windwp/nvim-autopairs' -- Autopairs
  use 'windwp/nvim-ts-autotag' -- Autotag

  use 'kyazdani42/nvim-web-devicons' -- File Icons
end)
