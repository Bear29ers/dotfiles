#!/usr/bin/env bash
# Copilot CLI statusLine script
# Reads JSON from stdin (provided by copilot CLI's statusLine.command feature)
# and outputs a single formatted line showing context token usage, premium
# request count, and AI credits consumed.
#
# Install dependency:  brew install jq
# Symlink:            ~/.copilot/statusline.sh -> <dotfiles>/.copilot/statusline.sh

if ! command -v jq &>/dev/null; then
  echo " copilot [jq not found: brew install jq]"
  exit 0
fi

input=$(cat)
q() { echo "$input" | jq -r "$1" 2>/dev/null || echo ""; }

# Model name — strip common prefixes to keep the line short
model=$(q '.model.display_name // .model.id // "copilot"')

# Context tokens used (format as "Xk" when >= 1000)
ctx_used=$(echo "$input" | jq -r '
  (.context_window.current_context_tokens // 0) as $n |
  if $n >= 1000 then (($n / 1000 | floor) | tostring) + "k"
  else ($n | tostring)
  end
' 2>/dev/null || echo "0")

# Context window total capacity
ctx_total=$(echo "$input" | jq -r '
  (.context_window.displayed_context_limit // 0) as $n |
  if $n >= 1000 then (($n / 1000 | floor) | tostring) + "k"
  else ($n | tostring)
  end
' 2>/dev/null || echo "?")

# Usage percentage (integer)
ctx_pct=$(q '(.context_window.current_context_used_percentage // 0) | floor | tostring')

# Premium requests consumed this session
premium=$(q '.cost.total_premium_requests // .total_premium_requests // 0')

# AI credits consumed (formatted string from API, e.g. "1.23")
credits=$(q '.ai_used.formatted // ""')

# Compose status line
status=" ${model} │ ctx ${ctx_used}/${ctx_total} (${ctx_pct}%) │  ${premium}"
[ -n "$credits" ] && status="${status} │  ${credits}"

echo "$status"
