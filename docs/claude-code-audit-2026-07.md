# Claude Code セットアップ監査レポート

- **診断日**: 2026-07-04
- **方法**: read-only の並列監査(8エージェント: ホーム構造 / ~/.claude / dotfiles リポジトリ / 各プロジェクト設定 / MCP・自動化 / コンテキスト効率 / MCP実使用統計 / settings.local.json 検査)+ 網羅性チェック + 設計エージェントによる裏取り(git log 実測・remote 確認)
- **スコープ**: ホーム全体の構造 + 開発領域の深掘り。Documents / Downloads / Desktop / Pictures / Movies / Music は完全対象外
- **確定済みの方針**(本レポートはこの決定を前提に設計):
  1. プロジェクト配置 = **ハイブリッド**(GitHub リポは ghq、学習用は `~/Developer/sandbox/`)
  2. RTK = **完全撤去**
  3. デフォルトモデル = **opusplan 維持**

> ⚠️ 本レポートは診断と提案のみ。記載のアクションは未実行であり、フェーズごとに承認を得てから実施する。

---

## 1. 診断サマリ

### 健全な点

- **MCP サーバーに無駄なし**: 設定済み4サーバー(context7 / playwright / serena / headroom)+ claude.ai コネクタ2つ(Notion / health-data-hub)はすべて実使用中(トランスクリプト実測 計3,152呼び出し)。削除候補ゼロ
- **コミット規約は完全遵守**: 直近20コミットすべて cz-emoji 形式に準拠(ただし機械的担保はなく規律のみ)
- **常時ロードは約1,497トークンと比較的軽量**(それでも約69%削減の余地あり → §4.2)
- **permissions のグローバル設計は堅実**: deny に sudo / git reset / rebase / rm -rf / シークレット読み書き、ask に commit / push / npm 等
- **自動メモリのインデックスは肥大化していない**(むしろ未活用 → §6)

### 主要な問題(詳細は §3 マトリクス)

1. **`~/.claude/settings.json` のドリフト**: symlink のはずが実ファイル化し、repo 版(opusplan / `rtk hook claude`)とローカル版(fable5 / `rtk-rewrite.sh`)が乖離。設定の権威ソースが崩壊している
2. **RTK フックが機能不全**: `rtk` バイナリ未インストールで PreToolUse フックは silent no-op。一方 RTK.md(約241トークン)だけが全セッションに常時ロードされ続けている → **撤去決定済み**
3. **symlink 未作成 6件**: `~/.config/tmux`、`~/.gitignore`、`~/.copilot/settings.json`、`~/.copilot/statusline.sh`、VS Code settings.json。CLAUDE.md の symlink 表(16件)と実態(9件)が不一致
4. **bootstrap スクリプト不在**: symlink はすべて手動作成。上記の欠損・ドリフトはこれの帰結
5. **ホームのクラッタ**: 1.6GB の Java ヒープダンプ、`token.txt`(2022年・機密疑い)、nvim.bak 665MB、orphan node_modules 等 → 約2.3GB+ 回収可能
6. **ai-chat の permission 過剰**: `Bash(node *)`(実質任意コード実行)、`Bash(pnpm dlx *)`(任意リモートコード実行)、`Bash(docker build *)` を無確認 allow
7. **`~/.claude/.claude.json` の MCP シャドウイング**: そのスコープで headroom + serena のみ定義し、context7 / playwright を欠落させている
8. **skills / agents / rules / output-styles すべて未構築**: handover が旧 `commands/` 形式のまま未移行
9. **プロジェクト配置の不統一**: ghq は .gitconfig 設定済み・Brewfile 収載済みなのに未使用。~/Developer 配下は言語別18フォルダで命名混在(lowercase / kebab / PascalCase)

---

## 2. 現状マップ

### 2.1 ディレクトリ全体(開発領域)

```
/Users/bear29ers/
├── dotfiles/                 # git リポ(設定のソース)
├── Developer/                # 18 言語/フレームワーク別フォルダ、git リポは 8 つのみ
│   ├── bear29ers.com/        # repo(メインプロジェクト、Next.js 15)
│   ├── Bear29ers/            # repo(プロフィール README)
│   ├── uiux/  python/        # repo(python は remote なし)
│   ├── docker-practice/      # repo(他者 suzuki-hoge のクローン)
│   ├── PolaroidStackGrid/    # repo(他者 codrops のクローン)
│   ├── claude/
│   │   ├── ai-chat/          # repo(CLAUDE.md 12KB、handovers 6)
│   │   └── todo/             # repo(remote 名は claude-todo)
│   ├── javascript/ node/ react/ ruby/ three/ typescript/ vue/
│   ├── web-api/ webpack/ website/        # 非 repo の学習フォルダ群
│   ├── 202510_assessment.md  # 迷子ファイル
│   └── gitignore.txt         # 迷子ファイル
├── myws/
│   ├── health-data-hub/      # repo(Python、claude.ai コネクタの参照先)
│   └── data/                 # Apple Health エクスポート(非 git)
└── (クラッタ) java_error_in_webstorm.hprof 1.6GB / token.txt /
    node_modules 6.6MB + package.json + package-lock.json /
    colors.sh / terminfo.src 1.1MB / tmux-256color.info
```

- `~/.local/share/`: nvim 1.9GB(現役)+ **nvim.bak 665MB(残骸)**
- `~/.config/`: fish / nvim / karabiner は dotfiles への symlink。gcloud(85MB)/ github-copilot / configstore / anyenv はマシン固有(dotfiles 管理外で妥当)
- `~/.ghq`: **存在しない**(.gitconfig に `ghq.root = ~/.ghq` 設定済み、Brewfile に ghq + peco 収載済み)
- Developer 配下の node_modules: 5,521 ディレクトリ(数 GB 規模)

### 2.2 symlink 検証表(CLAUDE.md の表 16件に対する実態)

| 対象 | 状態 |
|---|---|
| `~/.config/fish` `~/.config/nvim` `~/.ideavimrc` lazygit config `~/.czrc` `~/.gitconfig` `~/.claude/CLAUDE.md` `~/.claude/commands` `~/.claude/statusline.sh` | ✅ 正常(9件) |
| `~/.config/tmux` | ❌ 未作成(tmux 設定が読み込まれていない可能性) |
| `~/.gitignore` | ❌ 未作成 |
| `~/.copilot/settings.json` `~/.copilot/statusline.sh` | ❌ 未作成(`~/.copilot/` 自体なし) |
| `~/Library/Application Support/Code/User/settings.json` | ❌ 未作成 |
| `~/.claude/settings.json` | ⚠️ **実ファイル化してドリフト**(local: fable5 + rtk-rewrite.sh / repo: opusplan + rtk hook claude) |
| `~/.config/karabiner/karabiner.json` | ⚠️ 実ファイル(Karabiner アプリが自動上書きするため symlink 不可。例外として扱うべき) |
| ホーム直下 `.tmux.conf` `.tmux.conf.local` `.prettierrc.js` `Brewfile` | ✅ リンクは生きているが、相対/絶対パス混在。`.prettierrc.js` は `dotfiles/null-ls/` という珍しいサブディレクトリ参照 |

### 2.3 Claude Code 設定の所在

| 場所 | 内容 |
|---|---|
| `~/dotfiles/.claude/` | CLAUDE.md(106行・5,025B ≈ 1,256tok)、settings.json、statusline.sh、commands/handover.md(51行・frontmatter なし) |
| `~/.claude/`(ローカルのみ) | RTK.md(964B ≈ 241tok・全セッション @import)、hooks/rtk-rewrite.sh、settings.json(ドリフト)、.claude.json(MCP シャドウイング)、*.bak ×3 + commands.bak/(2026年5月の残骸)、plans/ ×2 |
| skills / agents / rules / output-styles / keybindings.json | **すべて不在** |
| managed settings(`/Library/Application Support/ClaudeCode/`) | 不在(個人マシンとして正常) |
| プラグイン | lua-lsp / typescript-lsp / pr-review-toolkit(公式マーケットプレイス、全て有効) |

**常時ロードの内訳**(グローバル CLAUDE.md チェーン):

| セクション | サイズ | 概算トークン |
|---|---|---|
| Commit Message Convention(59行絵文字テーブル含む) | 3,545B | ~886 |
| Test Code Requirements | 1,184B | ~296 |
| Session Handover | 247B | ~61 |
| @RTK.md | 964B | ~241 |
| **合計** | **5,989B** | **~1,497** |

**プロジェクト側**:

| プロジェクト | CLAUDE.md | handovers | 特記 |
|---|---|---|---|
| bear29ers.com | 3.5KB ✅ | 5件 | 良好な状態 |
| ai-chat | 12KB(肥大) | 6件 | `.serena/project.yml` が git 追跡+modified、settings.local.json に過剰許可 |
| health-data-hub | **なし** | 6件 | settings.local.json は健全(82B) |
| claude/todo | 11B スタブ(`@AGENTS.md` リンク切れ) | - | `.serena/` が .gitignore 未記載 |
| 学習系5リポ | なし | - | 非アクティブ(意図的で妥当) |

### 2.4 MCP・使用統計(トランスクリプト実測)

| サーバー | 呼び出し数 | 用途 |
|---|---|---|
| playwright | 1,241 | ブラウザ自動化(最多) |
| serena | 910 | シンボル操作・コード支援 |
| claude.ai Notion | 439 | - |
| claude.ai health-data-hub | 245 | 健康データ照会 |
| context7 | 142 | ライブラリドキュメント |
| headroom | 128 | コンテキスト圧縮 |

コマンド使用: `/compact` 4回、`/clear` 7回、`/model` 11回。自動化(crontab / LaunchAgents / GitHub Actions / pre-commit / husky): **すべてなし**。

---

## 3. 問題マトリクス(影響度 × 工数)

| # | 問題 | 根拠 | 影響度 | 工数 | 優先度 |
|---|---|---|---|---|---|
| 1 | `~/token.txt` 放置(機密疑い・2022年) | `~/token.txt` 41B | 高 | 低 | **P1** |
| 2 | settings.json ドリフト(権威ソース崩壊) | §2.2 | 高 | 低 | **P1** |
| 3 | RTK 機能不全 + 241tok 常時ロード | rtk 未検出、RTK.md @import | 高 | 低 | **P1**(撤去決定済み) |
| 4 | symlink 未作成 6件 | §2.2 | 高 | 低 | **P1** |
| 5 | bootstrap スクリプト不在(#2・#4 の根本原因) | リポに install 系なし | 高 | 中 | **P2** |
| 6 | ディスク浪費 約2.3GB+(hprof 1.6GB、nvim.bak 665MB 等) | §2.1 | 中 | 低 | **P2** |
| 7 | ai-chat の permission 過剰 | settings.local.json 23エントリ | 中 | 低 | **P2** |
| 8 | `~/.claude/.claude.json` の MCP シャドウイング | context7/playwright 欠落 | 中 | 低 | **P2** |
| 9 | handover 未移行・CLAUDE.md に手続き混在 | commands/handover.md | 中 | 中 | **P2** |
| 10 | プロジェクト配置不統一(ghq 未使用・命名混在) | §2.1 | 中 | 高 | **P3** |
| 11 | cz-emoji 59行表の常時ロード(~886tok、実使用は17種のみ) | git log 実測 | 中 | 中 | **P3** |
| 12 | 自動メモリ・handover 運用の未活用 | MEMORY.md 計13行 | 低 | 低 | **P3** |
| 13 | todo の CLAUDE.md スタブ、health-data-hub の CLAUDE.md 不在、.serena の gitignore 漏れ | §2.3 | 低 | 低 | **P4** |
| 14 | symlink の相対/絶対混在、.prettierrc.js の変則配置 | §2.2 | 低 | 低 | **P4** |

---

## 4. 理想構成案

### 4.1 PC 全体(ハイブリッド方針)

**原則**: GitHub に remote を持つ git リポ → `~/.ghq/github.com/<owner>/<repo>`。remote なしの学習・実験 → `~/Developer/sandbox/`。**dotfiles だけは例外として `~/dotfiles` 据え置き**(絶対パス symlink 9本の参照先であり、移動コストが「移行コスト最小化」の方針に反するため)。

```
/Users/bear29ers/
├── dotfiles/                          # 例外: ghq 外に維持
├── .ghq/
│   └── github.com/
│       ├── Bear29ers/
│       │   ├── ai-chat/  Bear29ers/  bear29ers.com/
│       │   ├── claude-todo/           # remote 名に合わせて改名
│       │   ├── health-data-hub/  uiux/
│       ├── codrops/PolaroidStackGrid/ # 他者クローンは実 owner 配下
│       └── suzuki-hoge/docker-practice/
├── Developer/
│   └── sandbox/                       # remote なしの学習・実験置き場
│       ├── _notes/                    # 迷子ファイルの受け皿
│       ├── javascript/ node/ python/ react/ ruby/ three/
│       └── typescript/ vue/ web-api/ webpack/ website/
└── myws/
    └── data/                          # Apple Health データ(git 管理外を維持)
```

**命名規則**:

| 領域 | 規則 |
|---|---|
| `~/.ghq/` 配下 | GitHub 上のリポ名をそのまま(ghq の管理単位。改名しない) |
| `sandbox/` 配下 | 小文字 kebab-case。新規実験は `sandbox/<技術名>/<yyyymm>-<テーマ>` |
| 例外 | `~/dotfiles` のみホーム直下 |

**移行マッピング表**:

| 現在地 | 移行先 | 備考 |
|---|---|---|
| `Developer/bear29ers.com` | `~/.ghq/github.com/Bear29ers/bear29ers.com` | remote 確認済み |
| `Developer/Bear29ers` | `~/.ghq/github.com/Bear29ers/Bear29ers` | 〃 |
| `Developer/uiux` | `~/.ghq/github.com/Bear29ers/uiux` | 〃 |
| `Developer/claude/ai-chat` | `~/.ghq/github.com/Bear29ers/ai-chat` | `.serena/project.yml` が modified → 移行前に commit/破棄 |
| `Developer/claude/todo` | `~/.ghq/github.com/Bear29ers/claude-todo` | remote 名に合わせ改名 |
| `Developer/docker-practice` | `~/.ghq/github.com/suzuki-hoge/docker-practice` | 他者クローン |
| `Developer/PolaroidStackGrid` | `~/.ghq/github.com/codrops/PolaroidStackGrid` | 〃 |
| `Developer/python`(remote なし repo) | `~/Developer/sandbox/python` | `.git` ごと移動 |
| `Developer/{javascript,node,react,ruby,three,typescript,vue,web-api,webpack,website}` | `~/Developer/sandbox/<同名>` | 非 repo。node_modules は移行後に一括削除候補 |
| `Developer/claude/`(空親) | 削除 | 2 repo 移動後に rmdir |
| `Developer/202510_assessment.md` | `sandbox/_notes/` | 迷子ファイル |
| `Developer/gitignore.txt` | `sandbox/_notes/` or 削除 | 【要確認】dotfiles の .gitignore に統合済みなら削除 |
| `myws/health-data-hub` | `~/.ghq/github.com/Bear29ers/health-data-hub` | **移行前にコード内の `~/myws/data` 参照と claude.ai コネクタの DB パス設定を確認**【要確認】 |
| `myws/data/` | 据え置き | health-data-hub と MCP が参照。git 管理外を維持 |
| ホーム直下クラッタ | 削除(検証手順は §5 Phase 2) | token.txt は内容確認 → 失効 → 削除 |

### 4.2 Claude Code

**配置原則**: 常時必要 = CLAUDE.md / 手続き = skill / 強制したい = hook・permissions / 隔離したい = subagent

```
~/dotfiles/.claude/                    # 唯一のソース(git 管理)
├── CLAUDE.md                          # スリム化: ~1,497tok → ~460tok(69%減)
├── settings.json                      # opusplan 固定 / RTK 削除 / hygiene 追加
├── statusline.sh
├── skills/
│   ├── handover/SKILL.md              # commands/ から移行(frontmatter 付与)
│   └── test-quality/SKILL.md          # Test Code Requirements を移設
├── agents/
│   └── browser-verify.md              # playwright 作業のコンテキスト隔離
├── hooks/
│   └── validate-commit-msg.sh         # cz-emoji 形式のコミットメッセージ検証
├── references/
│   └── cz-emoji-types.md              # 59行フル表(@import しない = 常時コスト 0)
└── install.sh                         # 冪等 bootstrap(リポルートでも可)

~/.claude/                             # ランタイム専用。設定はすべて symlink
├── CLAUDE.md / statusline.sh          # 既存 symlink 維持
├── settings.json                      # 実ファイル → symlink に修復
├── skills/ agents/ hooks/ references/ # dotfiles への symlink(新規)
├── (削除) commands/ symlink、RTK.md、*.bak ×3、commands.bak/、.claude.json
└── (維持) projects/ plugins/ history.jsonl 等のランタイムデータ
```

**決定事項と根拠**:

| # | 決定 | 根拠 |
|---|---|---|
| 1 | **cz-emoji 表は「実使用17種の縮小版(~250tok)をインライン + フル表を references/ へ」**。skill への全面移設は不採用 | git log 実測: 本人 authored コミットで使用実績があるのは17種のみ(wrench 19回、sparkles 7回、heavy_plus_sign 6回が上位)。コミットはほぼ毎セッション発生するため、skill 不発火 = 規約違反に直結。縮小表インラインが信頼性最優先の解。表末尾に「該当なしの場合は references/cz-emoji-types.md 参照」の1行を追加 |
| 2 | **Test Code Requirements(~296tok)→ `skills/test-quality/SKILL.md`**。CLAUDE.md には「テストコードを書く際は必ず test-quality スキルを使用」の1行(~20tok)を残す | テスト作成は毎セッション発生しない。`rules/` は常時ロードのため移設しても削減にならず不採用 |
| 3 | **@RTK.md・rtk フック・rtk-rewrite.sh を削除** | 決定済み。rtk 未インストールで死んだ機構、241tok の常時削減 |
| 4 | **handover を `skills/handover/SKILL.md` に移行**(name: handover / description: セッション終了時・区切り時に引き継ぎノートを生成) | 手続き = skill の原則。`/handover` はそのまま使える。移行確認後に commands/ を削除 |
| 5 | **settings.json を symlink 修復し repo 版を正とする**。opusplan 固定、`autoCompactEnabled: true`・`cleanupPeriodDays: 30` を明示 | ユーザーレベルに settings.local.json は存在しない(managed / project local / project shared / user の4種のみ)。一時的なモデル変更は `/model` か `claude --model` で行う運用に統一。恒久差分が必要になったら fish の未追跡ファイルで環境変数を設定する逃げ道を README に明記 |
| 6 | **新フック: cz-emoji コミットメッセージ検証**(PreToolUse / Bash)。`git commit -m` の時のみ 1 行目を `^:[a-z0-9_]+: [a-z0-9]+: .+` + 72字制限で検証、違反は exit 2 で差し戻し | 「強制したい = hook」の原則そのもの。現状は規律のみで担保。非コミットコマンドは即 exit 0 でオーバーヘッドほぼゼロ |
| 7 | **新サブエージェント: `browser-verify` を1つだけ新設**。tools を playwright 系 MCP + Read に限定し、検証結果サマリのみ返す | playwright 1,241回(全 MCP 最多)。スナップショットは巨大で使い捨て =「隔離したい = subagent」に合致。serena はコード編集の主線なので隔離しない。レビューは pr-review-toolkit 導入済みで新設不要 |
| 8 | **MCP 修復: headroom / serena を user スコープへ昇格 → `~/.claude/.claude.json` 削除** | シャドウイング解消。プロジェクトチェックインの `.mcp.json` はソロ開発のため見送り(共同開発化したら再検討【要確認】) |
| 9 | **permissions 強化**: ai-chat から `Bash(node *)` / `Bash(pnpm dlx *)` / `Bash(docker build *)` / pnpm パス違い3重複を削除。グローバル ask に `Bash(docker *)` / `Bash(npx *)` / `Bash(pnpm dlx *)` を明示追加 | 任意コード実行相当の allow はグローバル方針(npm は ask)と矛盾 |
| 10 | **keybindings / output-styles / rules は新設しない** | 必要性を示す事実(不満・使用パターン)が監査で確認できず。「必要が生じてから」 |
| 11 | オプション【要確認】: PostToolUse フォーマッタ(`*.fish` → fish_indent、`*.lua` → stylua ※Brewfile 追加前提)、Notification フック(macOS 通知で入力待ちを知らせる) | 価値はあるが本人の作業スタイル次第 |

---

## 5. 段階的実行プラン

各フェーズは**個別に承認を得てから実行**。リスク表記: 低 = git/バックアップで即復旧可、中 = 手動復旧要、高 = 不可逆。

### Phase 0: dotfiles リポジトリの変更(リスク低・git revert 可)

1. `settings.json` 編集: RTK フック削除 / opusplan 維持 / `autoCompactEnabled: true`・`cleanupPeriodDays: 30` 追加 / ask に `docker *`・`npx *`・`pnpm dlx *` 追加 / `validate-commit-msg.sh` の PreToolUse 登録
2. `CLAUDE.md` スリム化: `@RTK.md` 行削除 / 絵文字表を17種版に縮小 / Test Code Requirements をポインタ1行に置換
3. 新規作成: `skills/handover/SKILL.md`、`skills/test-quality/SKILL.md`、`references/cz-emoji-types.md`、`hooks/validate-commit-msg.sh`、`agents/browser-verify.md`
4. `install.sh` 新規作成: 全 symlink を冪等に張る(既存実ファイルは `.bak` 退避 → `ln -sfn`)
5. リポの `CLAUDE.md` symlink 表を更新(skills / hooks / agents / references 追加、karabiner を「例外: アプリが書き換えるため symlink 不可」と明記、commands 行削除)
6. (任意)`null-ls/.prettierrc.js` をリポルートへ `git mv`【要確認】

### Phase 1: symlink 修復 + MCP 修復(リスク低・「退避 → 置換」の順序厳守)

```sh
# settings.json(Phase 0 で repo 版が正になっていること)
mv ~/.claude/settings.json ~/.claude/settings.json.pre-symlink.bak
ln -s /Users/bear29ers/dotfiles/.claude/settings.json ~/.claude/settings.json
# 検証: claude 起動 → /model が opusplan、フックエラーなし

# 欠損6件
ln -s /Users/bear29ers/dotfiles/.config/tmux ~/.config/tmux
ln -s /Users/bear29ers/dotfiles/.gitignore ~/.gitignore
mkdir -p ~/.copilot
ln -s /Users/bear29ers/dotfiles/.copilot/settings.json ~/.copilot/settings.json
ln -s /Users/bear29ers/dotfiles/.copilot/statusline.sh ~/.copilot/statusline.sh
# VS Code(実体があれば先に .bak 退避)
ln -s /Users/bear29ers/dotfiles/.config/vscode/settings.json \
  "/Users/bear29ers/Library/Application Support/Code/User/settings.json"

# 新設ディレクトリ
ln -s /Users/bear29ers/dotfiles/.claude/skills ~/.claude/skills
ln -s /Users/bear29ers/dotfiles/.claude/agents ~/.claude/agents
ln -s /Users/bear29ers/dotfiles/.claude/references ~/.claude/references
mv ~/.claude/hooks ~/.claude/hooks.pre-symlink.bak   # rtk-rewrite.sh 入りを退避
ln -s /Users/bear29ers/dotfiles/.claude/hooks ~/.claude/hooks

# MCP 修復
claude mcp add --scope user headroom -- headroom mcp serve
claude mcp add --scope user serena -- uvx --from git+https://github.com/oraios/serena \
  serena start-mcp-server --project-from-cwd --context claude-code --open-web-dashboard False
rm ~/.claude/.claude.json
# 検証: claude mcp list で 6 サーバーすべて見えること
```

- tmux XDG 化に伴い、`tmux kill-server` → 再起動 → `tmux show -g` で `~/.config/tmux/tmux.conf` が読まれることを確認してから、ホーム直下の `.tmux.conf` / `.tmux.conf.local` symlink を削除(tmux は `~/.tmux.conf` を優先するため残すと二重管理)
- karabiner は **symlink しない**(例外として文書化のみ)
- `/handover` が skill 版で動くことを確認後、`~/.claude/commands` symlink と repo 側 `commands/` を削除
- ロールバック: symlink を消して `.bak` を戻す

### Phase 2: ホームクリーンアップ(**削除前検証必須**・不可逆)

| 対象 | サイズ | 削除前の検証 |
|---|---|---|
| `~/token.txt` | 41B | **`cat` で内容確認 → どのサービスか特定 → 有効なら失効処理**【要確認】→ その後 rm |
| `~/java_error_in_webstorm.hprof` + `_56435.log` | 1.6GB | 2024年のダンプで解析予定なしを確認 |
| `~/.local/share/nvim.bak` | 665MB | `nvim` 起動 → `:checkhealth` 正常を確認 |
| `~/terminfo.src` `~/tmux-256color.info` | 1.1MB | `infocmp tmux-256color` が成功すること |
| `~/node_modules` `~/package.json` `~/package-lock.json` | 6.6MB | package.json に sass 以外の依存・scripts がないこと【要確認】 |
| `~/colors.sh` | 小 | 内容確認 → dotfiles 収容 or 削除【要確認】 |
| `~/.claude/` の残骸(*.bak ×3、commands.bak/、RTK.md、hooks.pre-symlink.bak/) | 数KB | Phase 0/1 完了後、新構成で1セッション正常動作を確認してから一括 rm |

Phase 1 で作った `*.pre-symlink.bak` は1〜2週間の安定稼働後に削除。

### Phase 3: ghq 移行(リスク中・git-safe 手順)

同一ボリューム内 `mv` なので瞬時・コピーなし。ロールバックは逆方向 mv。共通手順:

```sh
# 1) 事前検証
git -C <path> status --porcelain   # 空であること
git -C <path> stash list           # 空であること
git -C <path> remote -v            # owner 確認
# 2) 移動
mkdir -p ~/.ghq/github.com/<owner>
mv <path> ~/.ghq/github.com/<owner>/<repo>
# 3) 事後検証
git -C ~/.ghq/github.com/<owner>/<repo> status && git -C ... fetch origin
ghq list   # 認識されること
```

**順序**(影響の小さい順): ① docker-practice / PolaroidStackGrid(他者クローン)→ ② Bear29ers / uiux → ③ bear29ers.com / claude-todo(改名しつつ mv)→ ④ ai-chat(**事前に `.serena/project.yml` の modified を commit か破棄**【要確認】)→ ⑤ health-data-hub(**事前に `~/myws/data` への絶対パス参照と claude.ai コネクタの DB パス設定を確認**【要確認】)

- 非 repo 群: `mkdir -p ~/Developer/sandbox && mv ~/Developer/{javascript,node,python,react,ruby,three,typescript,vue,web-api,webpack,website} ~/Developer/sandbox/`、迷子ファイルは `sandbox/_notes/` へ
- **注意(事前告知)**: `~/.claude/projects/` の履歴・自動メモリは cwd パスがキーのため、移動後は新規扱いになる。handovers はリポ内なので一緒に移動する。MEMORY.md は計13行と小さく、必要なら手動転記【要確認】
- (任意)sandbox 配下の node_modules 一括削除(5,521 ディレクトリの大半、数 GB 回収): `find ~/Developer/sandbox -name node_modules -type d -prune -exec rm -rf {} +`【要確認】

### Phase 4: プロジェクト側の仕上げ(リスク低)

1. **ai-chat**: settings.local.json の過剰許可削除(§4.2 #9)/ `.gitignore` に `.serena/` 追加 + `git rm --cached -r .serena`(bear29ers.com 方式に統一)【要確認】/ 12KB の CLAUDE.md を 5KB 目標に整理【要確認】
2. **claude-todo**: スタブ CLAUDE.md を実体のある最小版に置換 or AGENTS.md 作成 / `.gitignore` に `.serena/` 追加
3. **health-data-hub**: CLAUDE.md 新規作成(データソース優先方針、`~/myws/data` のパス、スキーマ要点)
4. 学習系5リポ: 何もしない(意図的)
5. 新フック検証: わざと規約違反メッセージで commit してブロックされることを確認

### Phase 5: 習慣と自動化(リスク低)

1. **コミット規約の機械的担保**: Claude 側は Phase 0 のフックでカバー。手動コミット向けに `dotfiles/githooks/commit-msg` + `git config --global core.hooksPath` を追加するかは【要確認】(global hooksPath は husky 等を使うリポのフックを無効化する副作用あり。代替: 主要リポだけ個別設定)
2. **dotfiles CI**: GitHub Actions で `fish -n` 構文チェック(+ stylua 採用時は `--check`)
3. **brew bundle dump 月次**: 手動レビュー付きリマインダー運用(自動 cron はレビューなし commit を生むため非推奨)
4. **ghq ナビゲーション**: Brewfile 収載済みの peco + ghq で fish 関数(`ghq list | peco` → cd)を追加

---

## 6. 日々の活用の見直し

### 並列化(サブエージェント委譲)

- **ブラウザ検証は `browser-verify` サブエージェントへ**(playwright 1,241回 = 全 MCP 最多。スナップショットがメインコンテキストを圧迫する典型)。「この変更をブラウザで検証して結果だけ報告」と投げ、メインは実装を継続
- **大きめのコード探索は Explore 系サブエージェントへ**委譲し、結論とパスだけ受け取る。serena での精密なシンボル操作はメインスレッドで継続、という使い分け
- PR レビューは導入済みの pr-review-toolkit に集約(新設不要)

### コンテキスト経済

- 実測: `/compact` 4回・`/clear` 7回と低頻度。推奨: **タスク境界は `/handover` → `/clear`**(handover skill がストック化するので消してよい)、**タスク途中の逼迫は「残すべき内容の指示付き」`/compact`**
- `autoCompactEnabled: true` の明示はあくまで保険。境界での能動的 `/clear` を主とする
- CLAUDE.md スリム化で全セッションの初期コンテキストが約1,000トークン軽くなる(毎セッション累積)

### メモリ習慣

- 実測: MEMORY.md は4プロジェクト計13行とほぼ未活用。**handover = フロー(次セッションへの引き継ぎ)/ MEMORY.md = ストック(恒久的な学び)**と役割分担し、handover skill の手順末尾に「恒久化すべき学びは MEMORY.md へ昇格」を1行追加
- 注意: Phase 3 の ghq 移行で MEMORY.md はパス基準でリセットされるため、習慣づけは**移行後に開始**するのが効率的

### モデル運用(opusplan 固定下)

- `opusplan` = 計画は Opus・実行は下位モデルの自動使い分け。日常はこれで十分
- `/model` で fable5 系へ切り替える基準(実測11回の切替をルール化): **1M コンテキストが要る作業のみ**(多数ファイル横断リファクタ、長時間ブラウザ検証、巨大ログ解析)。終わったら opusplan に戻す
- `advisorModel: claude-opus-4-7` と `effortLevel: medium` は維持。難航するデバッグに限りセッション内で引き上げ【要確認】

### 自動化の優先順

1. cz-emoji コミット検証フック(効果/コスト比最大。唯一「規律頼み」だった規約の機械化)
2. install.sh(今回の symlink 欠損・ドリフトの再発防止そのもの)
3. dotfiles CI(fish 構文チェック)
4. brew bundle dump 月次リマインド
5. cron / スケジュールエージェントの新設は**見送り**(定期実行を要するワークフローが監査で確認できないため)

---

## 付録: 監査で読み取った主な数値

| 項目 | 実測値 |
|---|---|
| 常時ロードコンテキスト | 約1,497トークン → スリム化後 約460トークン |
| MCP 総呼び出し | 3,152回(playwright 1,241 / serena 910 / Notion 439 / health-data-hub 245 / context7 142 / headroom 128) |
| 本人コミットの cz-emoji 実使用 | 17種(wrench 19回、sparkles 7回、heavy_plus_sign 6回 ほか) |
| 回収可能ディスク | 約2.3GB+(hprof 1.6GB、nvim.bak 665MB ほか)+ sandbox の node_modules 数GB |
| symlink | 正常9 / 未作成6 / ドリフト2 |
| Developer 配下 node_modules | 5,521 ディレクトリ |
