#!/usr/bin/env bash
set -euo pipefail

theme="$HOME/.config/rofi/power-menu.rasi"
confirm_theme='window { width: 280px; } mainbox { padding: 10px; } listview { columns: 2; lines: 1; fixed-height: true; fixed-columns: true; spacing: 8px; } element { padding: 10px 12px; }'

cancel='󰜺  Cancel'
lock='󰌾  Lock'
sleep='󰒲  Sleep'
logout='󰗼  Logout'
restart='󰜉  Restart'
shutdown='󰐥  Shutdown'

confirm_action() {
  local action="$1"
  local choice

  choice=$(
    printf '%s\n%s\n' "$cancel" "$action" | rofi -dmenu -theme "$theme" -theme-str "$confirm_theme" -selected-row 0 || true
  )

  [[ "$choice" == "$action" ]]
}

selection=$(
  printf '%s\n' \
    "$cancel" \
    "$lock" \
    "$sleep" \
    "$logout" \
    "$restart" \
    "$shutdown" \
  | rofi -dmenu -theme "$theme" -selected-row 0 || true
)

case "$selection" in
  "$lock")
    pidof hyprlock >/dev/null || hyprlock
    ;;
  "$sleep")
    systemctl suspend
    ;;
  "$logout")
    hyprctl dispatch exit
    ;;
  "$restart")
    confirm_action "$restart" && systemctl reboot
    ;;
  "$shutdown")
    confirm_action "$shutdown" && systemctl poweroff
    ;;
  "$cancel"|"")
    exit 0
    ;;
esac
