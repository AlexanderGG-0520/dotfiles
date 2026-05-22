#!/usr/bin/env fish

echo "[portal] applying stable Hyprland + KDE fallback config..."

mkdir -p ~/.config/xdg-desktop-portal

string join \n ' \
'[preferred]'
'
'default=hyprland;kde' ' \
'org.freedesktop.impl.portal.FileChooser=kde'
'
'org.freedesktop.impl.portal.AppChooser=kde' ' \
'org.freedesktop.impl.portal.Settings=kde'
'
> ~/.config/xdg-desktop-portal/portals.conf

echo "[portal] masking broken GTK portal backend..."
systemctl --user mask xdg-desktop-portal-gtk.service
systemctl --user daemon-reload

echo "[portal] stopping old portal processes..."
systemctl --user stop xdg-desktop-portal.service 2>/dev/null
systemctl --user stop xdg-desktop-portal-hyprland.service 2>/dev/null
systemctl --user stop xdg-desktop-portal-gtk.service 2>/dev/null
pkill -f xdg-desktop-portal 2>/dev/null

echo "[portal] importing minimal session environment..."
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE

echo "[portal] resetting failed state..."
systemctl --user reset-failed

echo "[portal] starting Hyprland portal and main portal..."
systemctl --user restart xdg-desktop-portal-hyprland.service
systemctl --user restart xdg-desktop-portal.service

echo "[portal] status:"
systemctl --user status xdg-desktop-portal.service --no-pager -l
systemctl --user status xdg-desktop-portal-hyprland.service --no-pager -l

echo "[portal] dbus names:"
busctl --user list | grep -E 'org.freedesktop.portal.Desktop|desktop.hyprland|desktop.kde|desktop.gtk'
