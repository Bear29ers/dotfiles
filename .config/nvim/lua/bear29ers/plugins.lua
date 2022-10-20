local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed")
	return
end

vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
	use("wbthomason/packer.nvim") -- A use-package inspired plugin manager for Neovim

	use("navarasu/onedark.nvim") -- One dark and light colorscheme for Neovim
	use("nvim-lualine/lualine.nvim") -- A blazing fast and easy to configure Neovim statusline
	use({
		"nvim-treesitter/nvim-treesitter", -- Treesitter
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})

	use("neovim/nvim-lspconfig") -- LSP Config
	use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for built-in LSP
	use("hrsh7th/cmp-buffer") -- nvim-cmp source for buffer words
	use("hrsh7th/nvim-cmp") -- A completion engine
	use("hrsh7th/cmp-vsnip") -- nvim-cmp source for vim-vsnip
	use("L3MON4D3/LuaSnip") -- Snippet Engine for Neovim
	use("glepnir/lspsaga.nvim") -- Built-in LSP UI
	use("onsails/lspkind-nvim") -- VSCode-like Pictograms
	use("folke/lsp-colors.nvim") -- Create missing LSP diagnostics highlight

	use("williamboman/mason.nvim") -- Portable package manager for Neovim
	use("williamboman/mason-lspconfig.nvim") -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim

	use("nvim-lua/plenary.nvim") -- Lua Library
	use("nvim-telescope/telescope.nvim") -- Telescope
	use("nvim-telescope/telescope-file-browser.nvim") -- Telescope File Browser

	use("windwp/nvim-autopairs") -- Autopairs
	use("windwp/nvim-ts-autotag") -- Autotag

	use("akinsho/nvim-bufferline.lua") -- Bufferline

	use("kyazdani42/nvim-web-devicons") -- File Icons

	use("lewis6991/gitsigns.nvim") -- Super fast git decorations
	use("dinhhuy258/git.nvim") -- Clone of the vim-fugitive

	use("jose-elias-alvarez/null-ls.nvim") -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
	use("MunifTanjim/prettier.nvim") -- Prettier plugin for Neovim's built-in LSP client

	use("numToStr/Comment.nvim") -- Smart and powerful comment plugin for neov

	use({
		"iamcco/markdown-preview.nvim", -- Markdown Preview
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	use("norcalli/nvim-colorizer.lua") -- A high-performance color highlighter for Neovim
	use("lukas-reineke/indent-blankline.nvim") -- Indent Guides for Neovim
end)
