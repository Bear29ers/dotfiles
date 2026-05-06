local logo = [[
                    ██████        ██████████          ██████
                  ████████████████          ██████████████████
                ████████████                        ████████████
              ████████████                            ████████████
              ██████████                                ██████████
              ████████                                    ████████
                ████        ██████            ██████        ████
                  ██      ████████            ████████      ██
                  ██    ██████  ██            ██  ██████    ██
                  ██    ██████████            ██████████    ██
                  ██    ██████████  ████████  ██████████    ██
                    ██  ████████    ████████    ████████  ██
                    ██    ████                    ████    ██
                      ██                                ██
                        ██                            ██
                          ████                    ████
                            ████████████████████████
                            ████████        ████████
                            ██  ████        ████  ██
                            ██                    ██
                            ██                    ██
                              ████████████████████
                              ██████        ██████
                                ████        ████

                                  [bear29ers]
]]

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = logo,
        keys = {
          { icon = " ", key = "f", desc = "Find file",       action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New file",        action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "g", desc = "Find text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config",          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras",     action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy",           action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
        },
      },
    },
  },
}
