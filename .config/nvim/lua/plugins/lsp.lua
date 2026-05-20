return {
  -- mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "shfmt",
        "tailwindcss-language-server",
        "html-lsp",
        "css-lsp",
        "cssmodules-language-server",
        "emmet-language-server",
        "sqlls",
        "some-sass-language-server",
      })
    end,
  },
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      servers = {
        eslint = {
          settings = {
            useFlatConfig = true,
            experimental = {
              useFlatConfig = nil,
            },
          },
        },
        somesass_ls = {
          filetypes = { "scss", "sass", "css" },
        },
        stylelint_lsp = {
          filetypes = { "css", "scss", "less", "sass" },
          settings = {
            stylelintplus = {
              autoFixOnSave = true,
              autoFixOnFormat = true,
            },
          },
        },
      },
      setup = {
        eslint = function()
          Snacks.util.lsp.on(function(_, client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "ts_ls" or client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
}
