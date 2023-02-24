local status, mason = pcall(require, 'mason')
if (not status) then return end

local status2, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not status2) then return end

local status3, mason_null_ls = pcall(require, 'mason-null-ls')
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

mason_lspconfig.setup {
  automatic_installation = true
}

require("mason-null-ls").setup({
  ensure_installed = {
      -- Opt to list sources here, when available in mason.
  },
  automatic_installation = false,
  automatic_setup = true, -- Recommended, but optional
})