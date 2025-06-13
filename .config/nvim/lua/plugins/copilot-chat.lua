return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  opts = function(_, opts)
    -- 利用可能なモデルを確認してデフォルトを設定
    local function get_default_model()
      -- 有料プランで使用可能なモデル（優先順位順）
      local paid_models = {
        "claude-sonnet-4",
        "claude-3.7-sonnet",
        "o4-mini",
      }

      -- 無料プランで使用可能なモデル
      local free_model = "o3-mini"

      -- 環境変数やローカル設定でプランを判定
      local is_paid_plan = os.getenv("COPILOT_PAID_PLAN") == "true"
        or vim.fn.filereadable(vim.fn.expand("~/.copilot_paid")) == 1

      return is_paid_plan and paid_models[1] or free_model
    end

    opts = opts or {}
    opts.model = get_default_model()

    -- その他の設定
    opts.auto_follow_cursor = false
    opts.show_help = true

    return opts
  end,
}
