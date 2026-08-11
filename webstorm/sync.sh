#!/bin/bash
#
# WebStorm settings sync (copy-based, not symlinked).
#
# WebStorm's config dir is version-numbered (~/Library/Application Support/
# JetBrains/WebStorm<version>/) and the IDE rewrites options/*.xml on exit,
# so unlike most of this repo's configs, WebStorm settings cannot be
# symlinked (same hazard as Karabiner-Elements — see install.sh). Instead
# this script copies an explicit allowlist of files between the live config
# dir and webstorm/ in this repo.
#
# Usage:
#   ./webstorm/sync.sh pull     # live config -> repo (capture current settings)
#   ./webstorm/sync.sh push     # repo -> live config (apply on a new machine)
#   ./webstorm/sync.sh diff     # show drift between repo and live config
#   ./webstorm/sync.sh plugins  # print derived non-bundled plugin list
#
# WebStorm must be fully quit (Cmd+Q) for every subcommand — it flushes
# options/*.xml on exit, so reading or writing while it runs captures/
# clobbers stale state.
#
# Override the auto-detected config dir (e.g. for a dry-run push against a
# scratch copy) with WEBSTORM_CONFIG_DIR.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$DOTFILES/webstorm"
JB="$HOME/Library/Application Support/JetBrains"

# --- Allowlist ---------------------------------------------------------------
# options/: explicit files only (real, portable settings; excludes license
# files, machine-local churn, telemetry, and per-install GUIDs/account IDs —
# see docs/CLAUDE.md for the full rationale).
OPTIONS_FILES=(
  laf.xml colors.scheme.xml editor.xml editor-font.xml console-font.xml
  terminal-font.xml ide.general.xml terminal.xml debugger.xml diff.xml
  find.xml parameter.hints.xml images.support.xml csvSettings.xml textmate.xml
  vcs.xml spellchecker-dictionary.xml vim_settings.xml rainbow_brackets.xml
  KeyPromoterXSettings.xml nodejs.xml
)
# Tree dirs: glob-based so new color schemes etc. are picked up automatically.
TREE_GLOBS=( 'codestyles/*.xml' 'keymaps/*.xml' 'colors/*.icls' )

# --- Helpers -------------------------------------------------------------

webstorm_running() { pgrep -f 'WebStorm\.app/Contents/MacOS' >/dev/null 2>&1; }

require_quit() {
  if webstorm_running; then
    echo "FATAL   WebStorm is running — quit it first (it rewrites options/*.xml on exit)" >&2
    exit 1
  fi
}

# Defense in depth: even though the allowlist above never reaches the config
# dir root (where webstorm.key / plugin_PCWMP.license live), refuse outright
# if anything secret-looking is ever matched.
assert_not_secret() {
  case "${1##*/}" in
    *.key|*.license|*.pem|*.p12|*.jks)
      echo "FATAL   refusing to copy secret-looking file: $1" >&2
      exit 1
      ;;
  esac
}

# Split out from detect_config_dir(): bash 3.2 (macOS's /bin/bash) has a
# parser bug where a `case` pattern containing a bracket expression (e.g.
# `[0-9]`) nested inside a `for ... done | pipe` inside a `$(...)` inside a
# function body fails to parse. Keeping the case in its own top-level
# function avoids the nesting depth that triggers it.
is_webstorm_version_dir() {
  case "$1" in
    WebStorm[0-9]*) return 0 ;;
    *) return 1 ;;
  esac
}

detect_config_dir() {
  if [ -n "${WEBSTORM_CONFIG_DIR:-}" ]; then
    printf '%s\n' "$WEBSTORM_CONFIG_DIR"
    return
  fi

  local ver d b
  ver="$(
    for d in "$JB"/WebStorm*/; do
      [ -d "$d" ] || continue
      b="${d%/}"; b="${b##*/}"
      is_webstorm_version_dir "$b" && printf '%s\n' "${b#WebStorm}"
    done | sort -t. -k1,1n -k2,2n | tail -n1
  )"
  [ -n "$ver" ] && printf '%s\n' "$JB/WebStorm$ver"
}

CONFIG_DIR="$(detect_config_dir)"

require_config_dir() {
  if [ -z "$CONFIG_DIR" ] || [ ! -d "$CONFIG_DIR" ]; then
    echo "SKIP    WebStorm config dir not found under $JB" >&2
    echo "        Launch WebStorm once, complete setup, quit it, then re-run." >&2
    exit 1
  fi
}

# Enumerate every allowlisted relative path that exists under $1.
rel_paths() {
  local base="$1" f rel g
  for f in "${OPTIONS_FILES[@]}"; do
    printf 'options/%s\n' "$f"
  done
  for g in "${TREE_GLOBS[@]}"; do
    for f in "$base"/$g; do
      [ -e "$f" ] || continue
      rel="${f#"$base"/}"
      printf '%s\n' "$rel"
    done
  done
}

# copy_one <src-file> <dst-file> <verb-on-copy>
copy_one() {
  local src="$1" dst="$2" verb="$3"
  assert_not_secret "$src"
  assert_not_secret "$dst"

  if [ ! -e "$src" ]; then
    echo "SKIP    $dst (source missing)"
    return
  fi

  if [ -e "$dst" ] && cmp -s "$src" "$dst"; then
    echo "OK      $dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [ "$verb" = "COPY(push)" ] && [ -e "$dst" ]; then
    cp "$dst" "$dst.bak"
    echo "BACKUP  $dst -> $dst.bak"
  fi

  cp "$src" "$dst"
  echo "COPY    $dst"
}

# --- plugins ---------------------------------------------------------------

plugin_id() {
  local dir="$1" j x
  for j in "$dir"/lib/*.jar; do
    [ -e "$j" ] || continue
    x="$(unzip -p "$j" META-INF/plugin.xml 2>/dev/null | tr -d '\n' \
         | grep -o '<id>[^<]*</id>' | head -1 | sed 's/<[^>]*>//g')"
    if [ -n "$x" ]; then printf '%s\n' "$x"; return; fi
    x="$(unzip -p "$j" META-INF/plugin.xml 2>/dev/null | tr -d '\n' \
         | grep -o '<name>[^<]*</name>' | head -1 | sed 's/<[^>]*>//g')"
    if [ -n "$x" ]; then printf '%s\n' "$x"; return; fi
  done
}

derive_plugins() {
  require_config_dir
  if ! command -v unzip >/dev/null 2>&1; then
    echo "SKIP    unzip not found; cannot derive plugin list" >&2
    return 1
  fi

  local auto_installed='^(com\.intellij\.ml\.llm|org\.jetbrains\.junie)$'
  local bundled installed id name d

  # bundled_plugins.txt is "<id>|<category>" — keep just the id.
  bundled="$(cut -d'|' -f1 "$CONFIG_DIR/bundled_plugins.txt" 2>/dev/null | LC_ALL=C sort -u || true)"

  installed=""
  for d in "$CONFIG_DIR"/plugins/*/; do
    [ -d "$d" ] || continue
    name="${d%/}"; name="${name##*/}"
    id="$(plugin_id "$d")"
    [ -n "$id" ] || id="$name"
    if printf '%s\n' "$bundled" | grep -qxF "$id"; then
      continue
    fi
    if [[ "$id" =~ $auto_installed ]]; then
      continue
    fi
    installed="$installed$id"$'\t'"$name"$'\n'
  done

  printf '%s' "$installed" | LC_ALL=C sort
}

# --- Subcommands -------------------------------------------------------------

cmd_pull() {
  require_config_dir
  require_quit

  local rel src dst
  while IFS= read -r rel; do
    src="$CONFIG_DIR/$rel"
    dst="$REPO/$rel"
    copy_one "$src" "$dst" "COPY(pull)"
  done < <(rel_paths "$CONFIG_DIR")

  echo "$(basename "$CONFIG_DIR" | sed 's/^WebStorm//')" > "$REPO/.source-version"
  echo "OK      $REPO/.source-version"

  {
    echo "# Non-bundled WebStorm plugins, derived from the live install."
    echo "# Format: <plugin-id>\t<display-name (search this in Marketplace)>"
    echo "# Regenerate with: ./webstorm/sync.sh plugins > webstorm/plugins.txt"
    echo "# Reinstall manually: Settings > Plugins > Marketplace (no CLI installer exists)."
    derive_plugins
  } > "$REPO/plugins.txt"
  echo "OK      $REPO/plugins.txt"

  echo
  echo "Unallowlisted options/*.xml seen (not pulled — review if any matter):"
  local f base seen
  for f in "$CONFIG_DIR"/options/*.xml; do
    [ -e "$f" ] || continue
    base="${f##*/}"
    seen=0
    for o in "${OPTIONS_FILES[@]}"; do
      [ "$o" = "$base" ] && seen=1 && break
    done
    [ "$seen" = 0 ] && echo "  $base"
  done
  true
}

cmd_push() {
  require_config_dir
  require_quit

  if [ -f "$REPO/.source-version" ]; then
    local src_ver live_ver
    src_ver="$(cat "$REPO/.source-version")"
    live_ver="$(basename "$CONFIG_DIR" | sed 's/^WebStorm//')"
    if [ "${src_ver%%.*}" != "${live_ver%%.*}" ]; then
      echo "WARN    captured from $src_ver, installing into $live_ver — verify theme,"
      echo "        keymap and code style after first launch"
    fi
  fi

  local rel src dst
  while IFS= read -r rel; do
    src="$REPO/$rel"
    dst="$CONFIG_DIR/$rel"
    copy_one "$src" "$dst" "COPY(push)"
  done < <(rel_paths "$REPO")

  echo
  echo "Manual steps required after relaunching WebStorm:"
  echo "  1. Settings > Keymap -> select 'macOS copy' (no pointer file exists for this)"
  echo "  2. Settings > Plugins > Marketplace -> install everything in webstorm/plugins.txt"
  echo "  3. Verify theme is One Dark Vivid and code style is 2-space / single quotes"
}

cmd_diff() {
  require_config_dir
  require_quit

  local rel src dst status=0
  while IFS= read -r rel; do
    src="$REPO/$rel"
    dst="$CONFIG_DIR/$rel"
    if [ ! -e "$src" ] || [ ! -e "$dst" ]; then
      echo "SKIP    $rel"
      continue
    fi
    if cmp -s "$src" "$dst"; then
      echo "OK      $rel"
    else
      echo "DIFF    $rel"
      status=1
    fi
  done < <(rel_paths "$REPO")

  exit "$status"
}

cmd_plugins() {
  derive_plugins
}

usage() {
  echo "Usage: $(basename "$0") {pull|push|diff|plugins}" >&2
}

case "${1:-}" in
  pull) cmd_pull ;;
  push) cmd_push ;;
  diff) cmd_diff ;;
  plugins) cmd_plugins ;;
  *) usage; exit 2 ;;
esac
