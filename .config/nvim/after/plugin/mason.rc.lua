local status, mason = pcall(require, 'mason')
if (not status) then return end

local status2, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not status2) then return end

local status3, lspconfig = pcall(require, 'lspconfig')
if (not status3) then return end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
