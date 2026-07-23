# CachyOS Hyprland dotfiles

This repository captures the user-managed configuration for the current CachyOS + Hyprland desktop and CLI environment. It keeps paths relative to the home directory so the files can be linked back into place.

Primary managed configuration includes Hyprland, UWSM, Waybar, Rofi, SwayNC, Ghostty, Fish, Neovim, Fcitx5/Mozc, Quickshell's power HUD, GTK/Qt appearance, xsettingsd, and shell/Git startup files.

## Install

Clone this repository to `~/dotfiles`, then preview the links:

```sh
cd ~/dotfiles
./install.sh --dry-run
```

Run `./install.sh` to create only missing symbolic links. Existing files and links are never overwritten; the script prints a warning for each one. Review or back up an existing destination yourself before replacing it.

## Adding configuration safely

1. Copy only the specific file or small configuration subtree needed to reproduce the environment, preserving its path beneath this repository.
2. Exclude caches, histories, backups, lockfiles, downloads, session state, and generated output.
3. Inspect new content and scan it for credentials before committing.
4. Add the corresponding path to `install.sh`, then run `./install.sh --dry-run` to review its behavior.

Never add passwords, API keys, tokens, private keys, certificates, cloud or Kubernetes credentials, browser profiles, or authentication/session data. The Fish API-key export from the source system is deliberately omitted from this repository; provide credentials privately through your preferred secret-management method.
