local status, null_ls = pcall(require, 'null-ls')
if (not status) then return end

local augroup_format = vim.api.nvim_create_augroup('Format', { clear = true })

local mason_package = require('mason-core.package')
local mason_registry = require('mason-registry')

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

table.insert(sources, null_ls.builtins.diagnostics.fish)
table.insert(sources, null_ls.builtins.diagnostics.eslint_d.with({ diagnostics_format = '[eslint] #{m}\n(#{c})' }))

null_ls.setup {
  sources = sources,
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup_format,
        buffer = 0,
        callback = function() vim.lsp.buf.formatting_seq_sync() end
      })
    end
  end,
}
