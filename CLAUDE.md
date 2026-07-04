# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS managed by [Bear29ers](https://github.com/Bear29ers). Configs live under `.config/` (XDG layout) and are symlinked or copied to `~/.config/`.

## Common Commands

```sh
# Symlink all configs to their target locations (idempotent; backs up to .bak)
./install.sh

# Install all Homebrew dependencies
brew bundle

# Update Fish shell plugins
fisher update

# Apply Neovim plugin changes (runs inside nvim)
:Lazy sync
```

There are no build scripts — changes take effect by symlinking files to their target locations (run `./install.sh`) or restarting the relevant tool.

### Symlink Targets

| Source (in repo)                   | Target                                                  |
| ---------------------------------- | ------------------------------------------------------- |
| `.config/fish/`                    | `~/.config/fish/`                                       |
| `.config/nvim/`                    | `~/.config/nvim/`                                       |
| `.config/tmux/`                    | `~/.config/tmux/`                                       |
| `.config/vscode/settings.json`     | `~/Library/Application Support/Code/User/settings.json` |
| `lazygit/config.yml`               | `~/Library/Application Support/lazygit/config.yml`      |
| `.gitconfig`, `.gitignore`, `.czrc`, `.ideavimrc` | `~/`                                    |
| `.claude/CLAUDE.md`                               | `~/.claude/CLAUDE.md`                   |
| `.claude/settings.json`                           | `~/.claude/settings.json`               |
| `.claude/statusline.sh`                           | `~/.claude/statusline.sh`               |
| `.claude/skills/`                                 | `~/.claude/skills/`                     |
| `.claude/agents/`                                 | `~/.claude/agents/`                     |
| `.claude/hooks/`                                  | `~/.claude/hooks/`                      |
| `.claude/references/`                             | `~/.claude/references/`                 |
| `.copilot/settings.json`                          | `~/.copilot/settings.json`              |
| `.copilot/statusline.sh`                          | `~/.copilot/statusline.sh`              |

**Exception**: `.config/karabiner/karabiner.json` is **copied**, not symlinked — Karabiner-Elements rewrites the real file and would clobber a symlink. Sync changes back into the repo manually.

**Prerequisites (beyond Homebrew):**
- `npm i -g commitizen cz-emoji` — required for `git cz` in lazygit
- `brew install --cask copilot-cli` — Copilot CLI (for `<leader>pp` in nvim)
- `headroom copilot-auth login` — one-time Headroom ↔ Copilot OAuth (headroom-ai itself is installed as an MCP server for Claude Code)
- `brew install jq` — required by `.copilot/statusline.sh` for token display

## Commit Message Convention

Uses **commitizen with cz-emoji** (`.czrc`). Commit messages must start with an emoji type:

```
:sparkles: feat: add new keybinding
:wrench: conf: update nvim options
:bug: fix: correct fish alias
:fire: rem: remove unused plugin
```

Max subject length: 72 characters. The `:type: scope: description` format is enforced — always match existing commit style.

## Architecture

### Neovim (`.config/nvim/`)

LazyVim-based configuration. Entry point is `init.lua` which bootstraps `lazy.nvim`.

- `lua/config/` — Core overrides: `lazy.lua` (plugin manager setup), `keymaps.lua`, `options.lua`, `autocmds.lua`
- `lua/plugins/` — Individual plugin config files, one per concern (lsp.lua, telescope.lua, copilot.lua, etc.)

LSP is configured in `lua/plugins/lsp.lua` with mason-org/mason.nvim. Language extras enabled: TypeScript, Tailwind, Vue, JSON, Markdown, Docker, Git, YAML.

When adding a new plugin, create a new file under `lua/plugins/` following LazyVim's plugin spec format.

### Fish Shell (`.config/fish/`)

`config.fish` sets environment variables, PATH, rbenv init, and Claude Code settings (`DISABLE_NON_ESSENTIAL_MODEL_CALLS=1`). Docker aliases are in a separate `docker.fish` file. Plugins managed via Fisher: `z` (directory jumping) and `tide@v6` (prompt).

### tmux (`.config/tmux/`)

Based on [gpakosz/.tmux](https://github.com/gpakosz/.tmux). `.tmux.conf` is the upstream base (1400+ lines); all customizations go in `.tmux.conf.local` (One Dark theme, 24-bit color).

### Git (`.gitconfig`)

20+ aliases defined. Uses `nvimdiff` as merge/diff tool. GHQ root at `~/.ghq`. Configured for `git log` with graph formatting.

### VS Code / JetBrains

VS Code settings in `.config/vscode/settings.json` — vscode-neovim extension configured with `jj` escape. JetBrains Vim emulation in `.ideavimrc` with matching leader key (`space`) and `jj` escape.
