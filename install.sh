#!/bin/sh
# Link managed dotfiles into $HOME without replacing existing paths.

set -eu

dry_run=false
case "${1:-}" in
  "") ;;
  --dry-run) dry_run=true ;;
  *)
    printf '%s\n' "Usage: $0 [--dry-run]" >&2
    exit 2
    ;;
esac

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

files='
.gitconfig
.profile
.bashrc
.zshrc
.config/fish/config.fish
.config/fish/functions/code.fish
.config/fish/functions/prismlauncher-mc.fish
.config/ghostty/config
.config/ghostty/config.ghostty
.config/hypr/hyprland.lua
.config/hypr/xdph.conf
.config/hypr/config/animations.lua
.config/hypr/config/autostart.lua
.config/hypr/config/binds.lua
.config/hypr/config/colors.lua
.config/hypr/config/decorations.lua
.config/hypr/config/environment.lua
.config/hypr/config/inputs.lua
.config/hypr/config/misc.lua
.config/hypr/config/monitors.lua
.config/hypr/config/variables.lua
.config/hypr/config/windowrules.lua
.config/hypr/config/workspaces.lua
.config/nvim/init.lua
.config/nvim/lua/config/base.lua
.config/nvim/lua/plugins/colorscheme.lua
.config/nvim/lua/plugins/lsp.lua
.config/nvim/lua/plugins/syntax.lua
.config/nvim/after/plugin/colorscheme.lua
.config/nvim/after/plugin/lsp.lua
.config/rofi/config.rasi
.config/rofi/theme.rasi
.config/rofi/power-menu.rasi
.config/rofi/power-menu.sh
.config/swaync/style.css
.config/waybar/config
.config/waybar/style.css
.config/fcitx5/config
.config/fcitx5/profile
.config/fcitx5/conf/keyboard.conf
.config/fcitx5/conf/mozc.conf
.config/fcitx5/conf/notifications.conf
.config/fcitx5/conf/xim.conf
.config/quickshell/power-hud/shell.qml
.config/quickshell/power-hud/toggle.sh
.config/uwsm/env
.config/gtk-3.0/settings.ini
.config/gtk-4.0/settings.ini
.config/qt5ct/qt5ct.conf
.config/qt6ct/qt6ct.conf
.config/xsettingsd/xsettingsd.conf
'

printf '%s\n' "$files" | while IFS= read -r path; do
  [ -n "$path" ] || continue
  source_path=$repo_dir/$path
  destination=$HOME/$path

  if [ ! -f "$source_path" ]; then
    printf '%s\n' "warning: source is missing; skipping $source_path" >&2
    continue
  fi
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf '%s\n' "warning: destination exists; skipping $destination" >&2
    continue
  fi

  if [ "$dry_run" = true ]; then
    printf '%s\n' "would link $destination -> $source_path"
  else
    mkdir -p "$(dirname -- "$destination")"
    ln -s "$source_path" "$destination"
    printf '%s\n' "linked $destination -> $source_path"
  fi
done
