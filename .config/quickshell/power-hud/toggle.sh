#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.config/quickshell/power-hud"
qs="/usr/bin/quickshell"
target="power-hud"
log_file="/tmp/power-hud-toggle.log"
lock_file="/tmp/power-hud-toggle.lock"

log() {
  printf '%s %s\n' "$(date '+%F %T')" "$*" >>"$log_file"
}

running_instance() {
  pgrep -af -- "$qs" | grep -F -- "--path $config" >/dev/null
}

wait_for_instance() {
  local attempts=40

  while (( attempts > 0 )); do
    if running_instance; then
      return 0
    fi

    sleep 0.1
    ((attempts--))
  done

  return 1
}

toggle_hud() {
  "$qs" --path "$config" ipc call "$target" toggle >>"$log_file" 2>&1
}

start_hud() {
  "$qs" -n --path "$config" >>"$log_file" 2>&1 &
  log "start process launched pid=$!"
}

wait_for_toggle() {
  local attempts=60

  while (( attempts > 0 )); do
    if toggle_hud; then
      return 0
    fi

    sleep 0.05
    ((attempts--))
  done

  return 1
}

mkdir -p "$(dirname "$log_file")"
log "toggle requested"

exec 9>"$lock_file"
flock 9

if toggle_hud; then
  log "HUD toggled via ipc"
  exit 0
fi

log "ipc toggle failed"

if wait_for_instance; then
  log "running instance detected; waiting for ipc to become ready"
  if wait_for_toggle; then
    log "HUD toggled after waiting"
    exit 0
  fi

  log "running instance did not respond to ipc"
  exit 1
fi

log "no running instance detected; starting persistent HUD"
start_hud

if wait_for_toggle; then
  log "HUD started and toggled"
else
  log "HUD did not respond after start attempt"
  exit 1
fi
