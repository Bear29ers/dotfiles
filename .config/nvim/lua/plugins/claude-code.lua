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
      split_width_percentage = 0.35,
      auto_close = true,
    },
    -- terminal_cmd = vim.fn.expand("~/.claude/local/claude"),
  },
  keys = {
    { "<leader>ac",  nil,                              desc = "+claude" },
    { "<leader>acc", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
    { "<leader>acf", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    { "<leader>acr", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume" },
    { "<leader>acC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
    { "<leader>acm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    { "<leader>acb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add buffer" },
    { "<leader>acs", "<cmd>ClaudeCodeSend<cr>",        mode = "v", desc = "Send selection" },
    { "<leader>act", "<cmd>ClaudeCodeTreeAdd<cr>",     desc = "Add from tree", ft = { "neo-tree", "oil" } },
    { "<leader>aca", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept diff" },
    { "<leader>acd", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny diff" },
  },
  init = function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({ { "<leader>ac", group = "claude" } })
    end
  end,
}
