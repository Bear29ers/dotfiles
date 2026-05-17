<samp>

# My dotfiles

<img width="100%" alt="dotfiles01" src="https://user-images.githubusercontent.com/39920490/197185639-6d9070cc-eb3d-454c-b2cd-f25911b55de2.png">
<img width="100%" alt="dotfiles02" src="https://user-images.githubusercontent.com/39920490/197185802-c9713f94-f356-4c54-9838-0d0b76a854a8.png">
<br>
<br>
<br>

## Contents

This dotfiles contains a variety of setting files.

- Fish Shell config (`.config/fish/`)
- Neovim config (`.config/nvim/`)
- tmux config (`.config/tmux/`)
- git config (`.gitconfig`)
- Karabiner config (`.config/karabiner/`)
- VSCode settings (`.config/vscode/`)
- JetBrains / IdeaVim (`.ideavimrc`)
- lazygit config (`lazygit/`)
- commitizen / cz-emoji (`.czrc`)
- Claude Code settings (`.claude/`)
- Brewfile
  <br>

## Setup

Clone and symlink each config to its expected location:

| Source (in this repo)              | Target                                                          |
| ---------------------------------- | --------------------------------------------------------------- |
| `.config/fish/`                    | `~/.config/fish/`                                               |
| `.config/nvim/`                    | `~/.config/nvim/`                                               |
| `.config/tmux/`                    | `~/.config/tmux/`                                               |
| `.config/karabiner/karabiner.json` | `~/.config/karabiner/karabiner.json`                            |
| `.config/vscode/settings.json`     | `~/Library/Application Support/Code/User/settings.json`         |
| `lazygit/config.yml`               | `~/Library/Application Support/lazygit/config.yml`              |
| `.gitconfig`                       | `~/.gitconfig`                                                  |
| `.gitignore`                       | `~/.gitignore`                                                  |
| `.czrc`                            | `~/.czrc`                                                       |
| `.ideavimrc`                       | `~/.ideavimrc`                                                  |
| `.claude/CLAUDE.md`                | `~/.claude/CLAUDE.md`                                           |
| `.claude/settings.json`            | `~/.claude/settings.json`                                       |
| `.claude/statusline.sh`            | `~/.claude/statusline.sh`                                       |
| `.claude/commands/`                | `~/.claude/commands/`                                           |

**Prerequisites:**

```sh
# Install Homebrew dependencies
brew bundle

# Install commitizen (required for lazygit git cz command)
npm i -g commitizen cz-emoji

# Install Fish plugins
fisher update
```
  <br>

## Claude Code Settings

Portable Claude Code config (global instructions, permissions, statusline, slash commands) is managed under `.claude/` in this repo.

**What is tracked:**

| File / Dir              | Purpose                                          |
| ----------------------- | ------------------------------------------------ |
| `.claude/CLAUDE.md`     | Global instructions (commit convention, tests)  |
| `.claude/settings.json` | Permissions, model, statusline, theme           |
| `.claude/statusline.sh` | Custom statusline script (requires `+x`)        |
| `.claude/commands/`     | Custom slash commands (e.g. `/handover`)        |

Machine-local state (`sessions/`, `history.jsonl`, `memory/`, `plans/`, `plugins/`, etc.) is excluded via `.gitignore`.

**Setup on a new machine (run from the dotfiles root):**

```sh
mkdir -p ~/.claude

# Back up any files Claude Code created on first launch
[ -e ~/.claude/CLAUDE.md ]     && mv ~/.claude/CLAUDE.md     ~/.claude/CLAUDE.md.bak
[ -e ~/.claude/settings.json ] && mv ~/.claude/settings.json ~/.claude/settings.json.bak
[ -e ~/.claude/statusline.sh ] && mv ~/.claude/statusline.sh ~/.claude/statusline.sh.bak
[ -e ~/.claude/commands ]      && mv ~/.claude/commands      ~/.claude/commands.bak

# Symlink from this repo
ln -sf "$PWD/.claude/CLAUDE.md"     ~/.claude/CLAUDE.md
ln -sf "$PWD/.claude/settings.json" ~/.claude/settings.json
ln -sf "$PWD/.claude/statusline.sh" ~/.claude/statusline.sh
ln -sfn "$PWD/.claude/commands"     ~/.claude/commands

chmod +x ~/.claude/statusline.sh
```

> **Note:** `jq` must be installed (`brew install jq`) for `statusline.sh` to work.
  <br>

## Shell Settings

| Package                                                  | Description                                                                                       |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| [Fish Shell](https://fishshell.com/)                     | Fish is a smart and user-friendly command lineshell for Linux, macOS, and the rest of the family. |
| [Fisher](https://github.com/jorgebucaran/fisher)         | A plugin manager for Fish—the friendly interactive shell.                                         |
| [tmux](https://github.com/tmux/tmux)                     | tmux is terminal multiplexer.                                                                     |
| [z](https://github.com/jethrokuan/z)                     | z is a port of z for the fish shell                                                               |
| [eza](https://github.com/eza-community/eza)               | A modern replacement for ls.                                                                      |
| [peco](https://github.com/peco/peco)                     | Simplistic interactive filtering tool                                                             |
| [ghq](https://github.com/x-motemen/ghq)                  | 'ghq' provides a way to organize remote repository clones, like go get does.                      |
| [Tide](https://github.com/IlanCosman/tide)               | The ultimate Fish prompt.                                                                         |
| [Nerd Hack Font](https://github.com/source-foundry/Hack) | Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts.                   |

<br>
<br>

## Neovim Settings

<img width="100%" alt="dotfiles03" src="https://github.com/Bear29ers/dotfiles/assets/39920490/374e41ab-1617-431f-be64-86d8e847b27b">
<img width="100%" alt="dotfiles03" src="https://github.com/Bear29ers/dotfiles/assets/39920490/af1931d7-c46c-492c-b35a-89f7f37b7058">

### ✨Features

- 🔥 Transform your Neovim into a full-fledged IDE
- 💤 Easily customize and extend your config with [lazy.nvim](https://github.com/folke/lazy.nvim)
- 🚀 Blazingly fast
- 🧹 Sane default settings for options, autocmds, and keymaps
- 📦 Comes with a wealth of plugins pre-configured and ready to use

### 🛠️Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) **_(optional, but needed to display some icons)_**
- [lazygit](https://github.com/jesseduffield/lazygit) **_(optional)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that support true color and *undercurl*:
  - [kitty](https://github.com/kovidgoyal/kitty) **_(Linux & Macos)_**
  - [wezterm](https://github.com/wez/wezterm) **_(Linux, Macos & Windows)_**
  - [alacritty](https://github.com/alacritty/alacritty) **_(Linux, Macos & Windows)_**
  - [iterm2](https://iterm2.com/) **_(Macos)_**

</samp>
