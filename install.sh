#!/bin/bash
#
# Idempotent dotfiles bootstrap.
# Symlinks every config to its target location. Existing real files/dirs are
# backed up to <target>.bak before being replaced. Safe to re-run any time.
#
# Usage: ./install.sh (from anywhere; paths are resolved from this script)

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    echo "SKIP    $dst (source missing: $src)"
    return
  fi

  # Already pointing at the right place
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "OK      $dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  # Back up an existing real file/dir (or a wrong symlink)
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "BACKUP  $dst -> $dst.bak"
  fi

  ln -sfn "$src" "$dst"
  echo "LINK    $dst -> $src"
}

# --- XDG configs -------------------------------------------------------------
link .config/fish            "$HOME/.config/fish"
link .config/nvim            "$HOME/.config/nvim"
link .config/tmux            "$HOME/.config/tmux"

# karabiner: Karabiner-Elements rewrites the real file, so a symlink gets
# clobbered. Copy once if missing; afterwards sync back into the repo manually.
if [ ! -e "$HOME/.config/karabiner/karabiner.json" ]; then
  mkdir -p "$HOME/.config/karabiner"
  cp "$DOTFILES/.config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
  echo "COPY    $HOME/.config/karabiner/karabiner.json (symlink not supported)"
else
  echo "OK      $HOME/.config/karabiner/karabiner.json (copy, managed manually)"
fi

# --- App configs (macOS paths) ----------------------------------------------
link .config/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
link lazygit/config.yml           "$HOME/Library/Application Support/lazygit/config.yml"

# --- Home dotfiles -----------------------------------------------------------
link .gitconfig  "$HOME/.gitconfig"
link .gitignore  "$HOME/.gitignore"
link .czrc       "$HOME/.czrc"
link .ideavimrc  "$HOME/.ideavimrc"

# --- Claude Code -------------------------------------------------------------
link .claude/CLAUDE.md      "$HOME/.claude/CLAUDE.md"
link .claude/settings.json  "$HOME/.claude/settings.json"
link .claude/statusline.sh  "$HOME/.claude/statusline.sh"
link .claude/skills         "$HOME/.claude/skills"
link .claude/agents         "$HOME/.claude/agents"
link .claude/hooks          "$HOME/.claude/hooks"
link .claude/references     "$HOME/.claude/references"

# --- Copilot CLI -------------------------------------------------------------
link .copilot/settings.json  "$HOME/.copilot/settings.json"
link .copilot/statusline.sh  "$HOME/.copilot/statusline.sh"

# --- WebStorm (manual sync) --------------------------------------------------
echo "SKIP    WebStorm settings (run ./webstorm/sync.sh push with WebStorm quit)"

echo
echo "Done. Review any BACKUP lines above; remove the .bak files once verified."
