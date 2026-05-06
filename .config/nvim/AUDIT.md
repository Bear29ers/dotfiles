# Neovim / LazyVim 設定 監査レポート

> 監査日: 2026-05-06  
> ブランチ: `feature/update_with_claude`  
> Neovim 設定ディレクトリ: `~/.config/nvim/` (dotfiles: `.config/nvim/`)

---

## ファイル構成

| ファイル | 役割 |
|---|---|
| `init.lua` | エントリポイント。`require("config.lazy")` のみ。 |
| `lua/config/lazy.lua` | lazy.nvim ブートストラップ + LazyVim スペック。extras をインライン宣言。 |
| `lua/config/options.lua` | winbar・relativenumber・listchars のオーバーライド。 |
| `lua/config/keymaps.lua` | `<M-Up/Down/Left/Right>` ウィンドウリサイズのみ。 |
| `lua/config/autocmds.lua` | json/jsonc/markdown で `conceallevel = 0`。 |
| `lua/plugins/alpha.lua` | alpha-nvim のロゴ・ボタン設定。→ Snacks.dashboard に移行。 |
| `lua/plugins/colorscheme.lua` | `navarasu/onedark.nvim` を "darker" スタイルで適用。 |
| `lua/plugins/copilot-chat.lua` | CopilotChat のモデル動的選択（有料/無料プラン判定）。 |
| `lua/plugins/diffview.lua` | `sindrets/diffview.nvim` に `<leader>h*` キーマップ。 |
| `lua/plugins/example.lua` | ~~スターターテンプレート。`if true then return {}` で無効化。~~ **→ 削除済み** |
| `lua/plugins/lsp.lua` | Mason ensure_installed・lspconfig overrides・colorizer・nvim-cmp カスタム。 |
| `lua/plugins/mason-workaround.lua` | ~~obsolete な空ファイル。~~ **→ 削除済み** |
| `lua/plugins/neo-tree.lua` | hidden ファイル表示・.git/.DS_Store 除外。 |
| `lua/plugins/telescope.lua` | telescope-fzf-native・find_command・hidden=true。|
| `lua/plugins/treesitter.lua` | ensure_installed 24 言語・ts-autotag・treesitter-context。 |
| `lua/plugins/ui.lua` | noice.nvim ルートフィルタ + lsp_doc_border。 |
| `lua/plugins/claude-code.lua` | `coder/claudecode.nvim` Claude Code 統合。**→ 新規追加** |

---

## 有効な LazyVim Extras（`lua/config/lazy.lua` にインライン宣言）

| Extra | 行 | 備考 |
|---|---|---|
| `lang.typescript` | 14 | |
| `lang.tailwind` | 15 | |
| `lang.vue` | 16 | |
| `lang.json` | 17 | |
| `lang.ruby` | 18 | |
| `lang.markdown` | 19 | |
| `lang.docker` | 20 | |
| `lang.git` | 21 | |
| `lang.yaml` | 22 | |
| `linting.eslint` | 23 | |
| `formatting.prettier` | 24 | |
| `editor.telescope` | 25 | |
| `ai.copilot` | 27 | |
| `ai.copilot-chat` | 28 | |

> **注意**: `lazyvim.json` の `extras` 配列は空のままで extras はすべて `lazy.lua` にインライン宣言されている。`:LazyExtras` UI が実態を反映しない（未決事項参照）。

---

## 監査結果：問題一覧

### Severity: HIGH（起動時エラー・実害あり）

| # | 問題 | 場所 | 対応 |
|---|---|---|---|
| H1 | `nvim-cmp` と `blink.cmp` が両方インストールされている。LazyVim のデフォルトは `blink.cmp` に移行済みだが、`lsp.lua` は `nvim-cmp` をカスタマイズしており設定が dead 状態。 | `lsp.lua:71-92` | **blink.cmp に一本化** → nvim-cmp ブロック削除 |
| H2 | `nvim-autopairs` が `nvim-cmp` の `confirm_done` イベントに紐付いており、blink.cmp 環境では発火しない。LazyVim は `mini.pairs` を同梱済み。 | `treesitter.lua:46-67` | **nvim-autopairs ブロック削除** |
| H3 | 環境変数名 typo: `GLLBAL_GEMFILE`（正: `GLOBAL_GEMFILE`）。ruby_lsp の `BUNDLE_GEMFILE` に渡す値が常に nil になっている。 | `lsp.lua:41` | **修正済み** |

### Severity: MEDIUM（機能低下・保守性劣化）

| # | 問題 | 場所 | 対応 |
|---|---|---|---|
| M1 | `vim.loop.cwd()` は Neovim 0.10 以降で非推奨（`vim.uv.cwd()` に移行）。 | `lsp.lua:45` | **修正済み** |
| M2 | `require('lazyvim.util').telescope.config_files()` は現行 API で `LazyVim.pick.config_files()` にリネーム済み。同リポジトリの他箇所は既に新 API を使用。 | `alpha.lua:39` | **移行完了**（alpha.lua 削除により解消） |
| M3 | `CopilotChat.nvim` の `branch = "canary"` は upstream で `main` に統合済み。追従されない可能性あり。 | `copilot-chat.lua:3` | **削除済み** |
| M4 | `nvim-ts-autotag` の opts が `opts = { opts = { ... } }` と二重にネストされており、設定値がプラグインに渡らない。 | `treesitter.lua:36-44` | **修正済み**（flat に） |
| M5 | `tsserver` ブランチ判定（`client.name == "tsserver"`）。現在 LazyVim は `vtsls` を使用しており、この分岐は発火しない。 | `lsp.lua:54` | **修正済み**（`ts_ls` に更新） |
| M6 | Mason `ensure_installed` に `typescript-language-server` / `vue-language-server` が残るが、LazyVim の `lang.typescript` / `lang.vue` extras が別途 `vtsls` / `vue_ls` を導入するため重複。 | `lsp.lua:10,14` | **削除済み** |

### Severity: LOW（整理・クリーンアップ）

| # | 問題 | 場所 | 対応 |
|---|---|---|---|
| L1 | `example.lua` はスターターテンプレートの残骸（265行）。`if true then return {}` で完全に無効化されているが死んだコードが大量に残る。 | `lua/plugins/example.lua` | **削除済み** |
| L2 | `mason-workaround.lua` は自己廃止コメント付きの `return {}`。 | `lua/plugins/mason-workaround.lua` | **削除済み** |
| L3 | `ui.lua` の `nvim-notify` ブロック（`rcarriga/nvim-notify`）。`lazy-lock.json` に未インストール。Snacks.notifier が代替動作中。 | `ui.lua:19-25` | **削除済み** |
| L4 | `treesitter.lua` に `highlight.enable = true` / `indent.enable = true` が残るが LazyVim デフォルト値と同一。 | `treesitter.lua:5-6` | **削除済み** |
| L5 | `telescope.lua` の keys ブロック（68行分）は `lazyvim.plugins.extras.editor.telescope` が提供するキーマップを重複宣言。 | `telescope.lua:15-82` | **削除済み** |
| L6 | `alpha-nvim` は Snacks.dashboard で代替可能。LazyVim の現行デフォルトは Snacks.dashboard。 | `lua/plugins/alpha.lua` | **Snacks.dashboard に移行済み** |
| L7 | `.neoconf.json` に `neodev` 設定が残るが、LazyVim は `lazydev.nvim` に移行済み。`neodev.nvim` は未インストールのため dead config。 | `.neoconf.json` | 未対応（影響軽微） |
| L8 | `netrwPlugin` が `performance.rtp.disabled_plugins` から除外されていない（コメントアウト）。`neo-tree` 利用中のため不要。 | `lazy.lua:50` | 未対応（影響軽微） |
| L9 | `lazyvim.json` の `extras` 配列が空。すべての extras が `lazy.lua` にインライン宣言されており `:LazyExtras` UI に反映されない。 | `lazyvim.json` | 未対応（挙動に影響なし） |

---

## 適用済み変更のコミット対応表

| コミット | 内容 |
|---|---|
| `:pencil: docs:` | AUDIT.md 作成（本ファイル） |
| `:fire: rem:` | dead ファイル削除（example.lua, mason-workaround.lua） |
| `:fire: rem:` | nvim-notify dead block 削除（ui.lua） |
| `:bug: fix:` | GLLBAL_GEMFILE typo 修正、vim.loop→vim.uv、tsserver→ts_ls、ts-autotag opts 修正 |
| `:fire: rem:` | nvim-cmp / nvim-autopairs 撤去（blink.cmp / mini.pairs 一本化） |
| `:lipstick: ui:` | alpha → Snacks.dashboard 移行 |
| `:wrench: conf:` | Mason ensure_installed から重複エントリ削除 |
| `:wrench: conf:` | telescope.lua の重複 keys ブロック削除 |
| `:wrench: conf:` | CopilotChat branch = canary 削除 |
| `:sparkles: feat:` | Claude Code 統合（coder/claudecode.nvim） |

---

## 未決事項（今回のスコープ外）

| 項目 | 内容 |
|---|---|
| **nvim-treesitter rewrite** | lockfile が `main` ブランチを参照。treesitter の `main` ブランチは rewrite 済みで API が変わっている可能性あり。`:Lazy update` 後に `:TSInstall` の動作を検証すること。 |
| **mason-lspconfig 2.x** | 2.x でオートロード機構が変わった。LazyVim が対応済みかを `:checkhealth mason-lspconfig` で確認すること。 |
| **Telescope → Snacks.picker 移行** | LazyVim は Snacks.picker をデフォルト picker に移行中。`editor.telescope` extra は引き続き利用可能だが、将来的な移行を検討。 |
| **lazyvim.json への extras 移設** | `lazy.lua` にインラインの extras を `lazyvim.json` に移すと `:LazyExtras` UI と整合する。 |
| **netrwPlugin の無効化** | `lazy.lua` の `disabled_plugins` から `netrwPlugin` のコメントを外す（neo-tree 利用中のため不要）。 |
| **CopilotChat モデル ID 更新** | `copilot-chat.lua` の `claude-sonnet-4` / `claude-3.7-sonnet` は 2026-05 時点で旧世代。Copilot 経由で Claude 4.x 世代が使えるか要確認。 |
| **eslint useFlatConfig 設定** | `lsp.lua:31-36` の `useFlatConfig = true` は vscode-eslint-language-server >= 4 では自動検出になり不要な可能性。 |
