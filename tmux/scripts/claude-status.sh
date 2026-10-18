#!/bin/sh
# Claude Code hook: mirrors Claude's state into the @claude_status window option
# of the tmux window it runs in. Reads the hook payload JSON on stdin.
[ -n "$TMUX_PANE" ] || exit 0

input=$(cat)
event=$(printf '%s' "$input" | jq -r '.hook_event_name // empty')
tool=$(printf '%s' "$input" | jq -r '.tool_name // empty')
ntype=$(printf '%s' "$input" | jq -r '.notification_type // empty')

case "$event" in
  UserPromptSubmit|PostToolUse|PostToolUseFailure) state=thinking ;;
  PreToolUse)
    case "$tool" in
      AskUserQuestion|ExitPlanMode) state=waiting ;;
      *) state=thinking ;;
    esac ;;
  PermissionRequest) state=waiting ;;
  Notification)
    case "$ntype" in
      permission_prompt|elicitation_dialog) state=waiting ;;
      *) exit 0 ;;
    esac ;;
  Stop) state=done ;;
  SessionEnd) tmux set -w -u -t "$TMUX_PANE" @claude_status; exit 0 ;;
  *) exit 0 ;;
esac

tmux set -w -t "$TMUX_PANE" @claude_status "$state"
