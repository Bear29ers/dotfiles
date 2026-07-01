-- Copilot CLI in a snacks terminal split (right, 45 %) via Headroom proxy.
-- Mirrors the coder/claudecode.nvim pattern so both AI tools live side-by-side.
--
-- Prerequisites (run once in your shell):
--   npm i -g @github/copilot
--   pipx install "headroom-ai[all]"
--   headroom copilot-auth login
--
-- Keys:  <leader>p group
--   <leader>pp  — toggle Copilot CLI panel
--   <leader>pf  — focus Copilot CLI panel (show without toggle-close)

local CMD = "headroom wrap copilot --subscription -- --experimental --model gpt-4o"
local WIN = { position = "right", width = 0.45 }

return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>pp",
      function()
        Snacks.terminal.toggle(CMD, { win = WIN })
      end,
      desc = "Toggle Copilot",
    },
    {
      "<leader>pf",
      function()
        -- open (or re-focus) without toggling closed
        local term = Snacks.terminal.get(CMD)
        if term then
          term:show()
          term:focus()
        else
          Snacks.terminal(CMD, { win = WIN })
        end
      end,
      desc = "Focus Copilot",
    },
  },
  init = function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({ { "<leader>p", group = "copilot" } })
    end
  end,
}
