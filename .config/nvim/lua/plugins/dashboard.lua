vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#abb2bf" })
  end,
})

local logo_path = vim.fn.stdpath("config") .. "/assets/logo.png"

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
      },
    },
    dashboard = {
      preset = {
        header = "[bear29ers]",
        keys = {
          { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "g", desc = "Find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        {
          section = "terminal",
          cmd = "chafa " .. logo_path .. " --size 36x20 --symbols vhalf; sleep .1",
          width = 36,
          height = 20,
          padding = 1,
          indent = 12,
        },
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
