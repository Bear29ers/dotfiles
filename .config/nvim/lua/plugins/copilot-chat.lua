return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = function(_, opts)
    -- 利用可能なモデルを確認してデフォルトを設定
    local function get_default_model()
      -- claude-4が利用可能かチェック（Pro版）
      local models = {
        "claude-4",
        "claude-3.5-sonnet",
        "gpt-4",
      }

      -- 実際には利用可能なモデル一覧を取得する必要がありますが、
      -- 簡単な方法として環境変数やファイル存在チェックを使用
      for _, model in ipairs(models) do
        -- ここで実際の利用可能性をチェックする
        -- 今回は単純にclaude-4を試してフォールバック
        return model
      end

      return "gpt-4o-mini"
    end

    opts = opts or {}
    opts.model = get_default_model()

    -- その他の設定
    opts.auto_follow_cursor = false
    opts.show_help = true

    return opts
  end,
}
