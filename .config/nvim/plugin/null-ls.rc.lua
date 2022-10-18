local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

--local augroup_format = vim.api.nvim_create_augroup('Format', { clear = true })
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local mason_package = require("mason-core.package")
local mason_registry = require("mason-registry")

local sources = {}

for _, package in ipairs(mason_registry.get_installed_packages()) do
	local package_categories = package.spec.categories[1]
	if package_categories == mason_package.Cat.Formatter then
		table.insert(sources, null_ls.builtins.formatting[package.name])
	end
	if package_categories == mason_package.Cat.Linter then
		table.insert(sources, null_ls.builtins.diagnostics[package.name])
	end
end

null_ls.setup({
	debug = true,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
