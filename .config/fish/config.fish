source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
# Keep API keys and other credentials in a private, untracked environment file.
# This repository intentionally does not manage secrets.

if status is-login; and not set -q DISPLAY; and not set -q WAYLAND_DISPLAY; and uwsm check may-start -q 1
    exec systemd-cat -t uwsm_start uwsm start hyprland.desktop
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
