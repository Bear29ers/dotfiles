#!/bin/bash
# PreToolUse (Bash) hook: validate cz-emoji commit message format.
# Blocks `git commit -m` when the subject line does not match
# `:emoji_code: scope: description` or exceeds 72 characters.
# All other commands pass through immediately (exit 0).

input=$(cat)

# jq is required to parse the hook payload; fail open if missing
command -v jq >/dev/null 2>&1 || exit 0

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

# Match `git commit` even with intervening global options (e.g. `git -C <path> commit`)
printf '%s' "$cmd" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+([^;&|]*[[:space:]])?commit([[:space:]]|$)' || exit 0

# No inline message (e.g. --amend --no-edit, or editor-based) -> nothing to check
case "$cmd" in
  *-m*) ;;
  *) exit 0 ;;
esac

# Extract the subject (first line of the commit message)
if printf '%s' "$cmd" | grep -q '<<'; then
  # heredoc style: git commit -m "$(cat <<'EOF' ... EOF)"
  subject=$(printf '%s\n' "$cmd" | awk 'found { print; exit } /<</ { found=1 }')
else
  # inline style: git commit -m "message" / -m 'message'
  subject=$(printf '%s\n' "$cmd" | sed -nE "s/.* -m[[:space:]]+(\"([^\"]*)\"|'([^']*)').*/\2\3/p" | head -n1)
fi

# Could not extract a subject -> fail open rather than block legitimate commits
[ -z "$subject" ] && exit 0

if ! printf '%s' "$subject" | grep -qE '^:[a-z0-9_]+: [a-z0-9]+: .+'; then
  echo "Commit message must follow cz-emoji format ':emoji_code: scope: description' (e.g. ':wrench: conf: update nvim options'). Got: $subject" >&2
  exit 2
fi

if [ "${#subject}" -gt 72 ]; then
  echo "Commit subject exceeds 72 characters (${#subject}): $subject" >&2
  exit 2
fi

exit 0
