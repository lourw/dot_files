#!/bin/sh
# Merges ai/claude/hooks.json into ~/.claude/settings.json, replacing any
# earlier claude-status.sh entries and leaving other settings and hooks alone, and
# points statusLine at statusline.sh unless another status line is already set.
# Merged rather than symlinked because Claude Code rewrites settings.json.
# Prints "changed" when the file was updated. --remove strips the entries instead.
set -eu

dir=$(cd "$(dirname "$0")" && pwd)
hooks="$dir/hooks.json"
settings="${CLAUDE_SETTINGS:-$HOME/.claude/settings.json}"
[ "${1:-}" = "--remove" ] && remove=true || remove=false

mkdir -p "$(dirname "$settings")"
[ -s "$settings" ] || echo '{}' > "$settings"

new=$(jq --slurpfile h "$hooks" --arg sl "$dir/statusline.sh" --argjson remove "$remove" '
  def ours: any(.hooks[]?; .command | test("claude-status\\.sh"));
  .hooks //= {}
  | reduce ($h[0] | to_entries[]) as $e (.;
      .hooks[$e.key] = ([(.hooks[$e.key] // [])[] | select(ours | not)]
                        + (if $remove then [] else $e.value end))
      | if .hooks[$e.key] == [] then del(.hooks[$e.key]) else . end)
  | if .hooks == {} then del(.hooks) else . end
  | if (.statusLine.command // "" | test("statusline\\.sh$")) or (.statusLine | not) then
      if $remove then del(.statusLine) else .statusLine = {type: "command", command: $sl} end
    else . end
' "$settings")

if [ "$new" != "$(cat "$settings")" ]; then
  printf '%s\n' "$new" > "$settings"
  echo changed
fi
