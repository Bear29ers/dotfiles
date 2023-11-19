return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {},
    },
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
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
      "scss",
      "sql",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
  },
  config = function(_, opts)
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      check_ts = true,
      ts_config = {
        javascript = { "template_string" },
      },
    })

    require("nvim-treesitter.configs").setup(opts)
    require("nvim-ts-autotag").setup({
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    })
  end,
}
