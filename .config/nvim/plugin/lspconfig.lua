local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
	return
end

local status2, mason_lsp = pcall(require, "mason-lspconfig")
if not status2 then
	return
end

local protocol = require("vim.lsp.protocol")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist, opts)

-- LSP management
mason_lsp.setup({
	ensure_installed = {
		"sumneko_lua",
		"tsserver",
		"html",
		"cssls",
		"tailwindcss",
		"emmet_ls",
		"dockerls",
	},
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
mason_lsp.setup_handlers({
	function(server)
		local mason_opts = {
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", bufopts)
				vim.keymap.set("n", "sh", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
				vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
				vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", bufopts)
				vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", bufopts)
				vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>", bufopts)
				vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
				vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
				vim.keymap.set("n", "gf", vim.lsp.buf.formatting, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
			end,

			-- Set up completion using nvim_cmp with LSP source
			capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		}
		-- sumneko_lua
		if server == "sumneko_lua" then
			mason_opts.settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			}
		end

		nvim_lsp[server].setup(mason_opts)
	end,
})

-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "●" },
	severity_sort = true,
})

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
	update_in_insert = true,
	float = {
		source = "always", -- Or "if_many"
	},
})

-- Icons
protocol.CompletionItemKind = {
	"", -- Text
	"", -- Method
	"", -- Function
	"", -- Constructor
	"", -- Field
	"", -- Variable
	"", -- Class
	"ﰮ", -- Interface
	"", -- Module
	"", -- Property
	"", -- Unit
	"", -- Value
	"", -- Enum
	"", -- Keyword
	"﬌", -- Snippet
	"", -- Color
	"", -- File
	"", -- Reference
	"", -- Folder
	"", -- EnumMember
	"", -- Constant
	"", -- Struct
	"", -- Event
	"ﬦ", -- Operator
	"", -- TypeParameter
}
