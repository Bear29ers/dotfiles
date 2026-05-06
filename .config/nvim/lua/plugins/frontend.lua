return {
  -- TypeScript エラーメッセージを人間に読める形に翻訳
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    opts = {},
  },
  -- テンプレートリテラルが必要な場合に自動で backtick に変換
  {
    "axelvc/template-string.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
    opts = {},
  },
}
