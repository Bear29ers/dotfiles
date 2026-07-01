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
        tailwindcss = {
          -- Nvim 0.11+ の非同期 root_dir API に合わせた記述
          -- base/tailwind.config.ts を優先して上位ディレクトリを検索する
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local found = vim.fs.find(
              { "tailwind.config.ts", "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs" },
              { path = fname, upward = true }
            )[1]
            on_dir(found and vim.fs.dirname(found) or nil)
          end,
        },
        eslint = {
          settings = {
            useFlatConfig = true,
            -- eslint.config.mjsのある場所（リポジトリルート）を作業ディレクトリとして使用する
            -- これにより config: 'base/tailwind.config.ts' の相対パスが正しく解決される
            workingDirectory = { mode = "auto" },
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
  -- @vue/typescript-plugin のパス修正（LazyVim vue extra のパスが誤っているため上書き）
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local plugins = vim.tbl_get(opts, "servers", "vtsls", "settings", "vtsls", "tsserver", "globalPlugins") or {}
      for _, plugin in ipairs(plugins) do
        if plugin.name == "@vue/typescript-plugin" then
          plugin.location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin"
        end
      end
    end,
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
