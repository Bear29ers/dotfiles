return {
  -- mason
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
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
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
      local cmp = require("cmp")
      -- borders to cmp window
      local cmp_window = cmp.config.window
      opts.window = {
        completion = cmp_window.bordered(),
        documentation = cmp_window.bordered(),
      }
    end,
  },
}
