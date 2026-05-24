return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  opts = {
    terminal = {
      provider = "snacks",
      split_side = "right",
      split_width_percentage = 0.45,
      auto_close = true,
    },
    -- terminal_cmd = vim.fn.expand("~/.claude/local/claude"),
  },
  keys = {
    -- <leader>a* — Claude Code (2-key access, CopilotChat removed)
    { "<leader>aa", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",        desc = "Focus Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",         mode = "v", desc = "Send selection" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",        desc = "Add buffer" },
    { "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>",      desc = "Add from tree", ft = { "neo-tree", "oil" } },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",    desc = "Resume" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>",  desc = "Continue" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>",  desc = "Select model" },
    { "<leader>ao", "<cmd>ClaudeCodeDiffAccept<cr>",   desc = "Accept diff" },
    { "<leader>ax", "<cmd>ClaudeCodeDiffDeny<cr>",     desc = "Deny diff" },
  },
  init = function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({ { "<leader>a", group = "claude" } })
    end
  end,
}
