## Sapphire dotfiles

The canonical configurations are stored under `config/` and linked into
`~/.config`. Managed paths are `hypr`, `quickshell`, `ghostty`, and `fish`.
Rofi is intentionally unmanaged while it uses its application defaults.

Preview a migration:

```fish
fish scripts/link-dotfiles.fish --dry-run
```

Apply it after reviewing the plan:

```fish
fish scripts/link-dotfiles.fish
```

The script is conflict-aware and creates verified snapshots under
`.migration-backup/`. Historic repository configuration is preserved under
`legacy/` for explicit review before any future commit. Browser data, credentials, tokens,
caches, sockets, PID files, and runtime state are intentionally excluded.
