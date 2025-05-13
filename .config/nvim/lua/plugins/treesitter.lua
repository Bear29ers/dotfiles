return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {},
    },
    "hrsh7th/nvim-cmp",
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
    ensure_installed = {
      "bash",
      "css",
      "dockerfile",
      "fish",
      "gitignore",
      "html",
      "http",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "regex",
      "ruby",
      "scss",
      "sql",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    require("nvim-ts-autotag").setup({
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    })

    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      check_ts = true,
      ts_config = {
        javascript = { "template_string" },
      },
    })

    pcall(function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end)
  end,
}
