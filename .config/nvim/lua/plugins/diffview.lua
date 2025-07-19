return {
  "sindrets/diffview.nvim",
  keys = {
    { mode = "n", "<leader>hh", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "diff from previous" },
    { mode = "n", "<leader>hf", "<cmd>DiffviewFileHistory %<CR>", desc = "file change history" },
    { mode = "n", "<leader>hc", "<cmd>DiffviewClose<CR>", desc = "close diffview" },
    { mode = "n", "<leader>hd", "<cmd>Diffview<CR>", desc = "display diffview" },
  },
}