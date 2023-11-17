return {
  -- messages, cmdline and the popupmenu
  -- noice
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- skip no information available
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      -- display lsp doc border
      opts.presets.lsp_doc_border = true
    end,
  },
  --notify
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 10000,
    },
  },
}
