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

  use 'neovim/nvim-lspconfig' -- LSP Config
  use 'onsails/lspkind-nvim' -- VSCode-like Pictograms
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for built-in LSP
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/nvim-cmp' -- A completion engine
  use 'L3MON4D3/LuaSnip' -- Snippet Engine for Neovim
  use 'glepnir/lspsaga.nvim' -- Built-in LSP UI
  use 'folke/lsp-colors.nvim' -- Create missing LSP diagnostics highlight

  use 'williamboman/mason.nvim' -- Portable package manager for Neovim
  use 'williamboman/mason-lspconfig.nvim' -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim

  use {
    'nvim-treesitter/nvim-treesitter', -- Treesitter
    run = function() require('nvim-treesitter.install').update { with_sync = true } end
  }

  use 'nvim-lua/plenary.nvim' -- Lua Library
  use 'nvim-telescope/telescope.nvim' -- Telescope
  use 'nvim-telescope/telescope-file-browser.nvim' -- Telescope File Browser

  use 'windwp/nvim-autopairs' -- Autopairs
  use 'windwp/nvim-ts-autotag' -- Autotag

  use 'akinsho/nvim-bufferline.lua' -- Bufferline

  use 'kyazdani42/nvim-web-devicons' -- File Icons

  use 'lewis6991/gitsigns.nvim' -- Super fast git decorations
  use 'dinhhuy258/git.nvim' -- Clone of the vim-fugitive

  use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  use 'MunifTanjim/prettier.nvim' -- Prettier plugin for Neovim's built-in LSP client
end)
