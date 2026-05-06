return {
  -- mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "cssmodules-language-server",
        "vue-language-server",
        "emmet-language-server",
        "sqlls",
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
        ruby_lsp = {
          mason = false,
          enabled = true,
          cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv("GLOBAL_GEMFILE") },
          cmd = { os.getenv("RUBY_LSP_PATH") or vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
          filetypes = { "ruby", "eruby" },
          root_dir = function()
            return vim.uv.cwd()
          end,
        },
      },
      setup = {
        eslint = function()
          Snacks.util.lsp.on(function(buf, client)
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
