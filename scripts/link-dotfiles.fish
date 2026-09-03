#!/usr/bin/env fish
# Link the live-authoritative Sapphire desktop configuration into this repo.

set -l dry_run 0
for argument in $argv
    switch $argument
        case --dry-run
            set dry_run 1
        case '*'
            echo "Unknown option: $argument" >&2
            echo "Usage: "(status filename)" [--dry-run]" >&2
            exit 2
    end
end

set -l repo_root (realpath (dirname (dirname (status filename))))
set -l config_root "$repo_root/config"
set -l live_root "$HOME/.config"
set -l timestamp (date +%Y%m%d-%H%M%S)
set -l backup_root "$repo_root/.migration-backup/$timestamp"
set -l managed hypr quickshell ghostty fish
set -l conflicts 0

function plan --argument-names message
    echo "PLAN  $message"
end

function conflict --argument-names message
    echo "CONFLICT  $message" >&2
    set -g conflicts 1
end

for name in $managed
    set -l live "$live_root/$name"
    set -l repo "$config_root/$name"

    if test -L "$live"
        set -l resolved (readlink -f "$live")
        if test "$resolved" = "$repo"
            echo "OK    $live -> $repo"
        else
            conflict "$live is linked to $resolved, not $repo"
        end
        continue
    end

    if test -e "$live"
        if test -e "$repo"
            conflict "$live and $repo both contain real data"
        else
            plan "backup $live -> $backup_root/$name"
            plan "move $live -> $repo"
            plan "link $live -> $repo"
        end
    else
        if test -e "$repo"
            plan "link missing $live -> $repo"
        else
            conflict "neither live path nor repo target exists for $name"
        end
    end
end

if test $conflicts -ne 0
    echo "No changes made because conflicts were found." >&2
    exit 1
end

if test $dry_run -eq 1
    echo "Dry run complete; no changes made."
    exit 0
end

for name in $managed
    set -l live "$live_root/$name"
    set -l repo "$config_root/$name"

    if test -L "$live"
        continue
    end

    if test -e "$live"
        mkdir -p "$config_root" "$backup_root"
        cp -a "$live" "$backup_root/$name"
        if not diff -qr "$live" "$backup_root/$name" >/dev/null
            echo "Backup verification failed for $live; leaving it unchanged." >&2
            exit 1
        end
        mv "$live" "$repo"
    end

    if not test -e "$repo"
        echo "Missing repo target after migration: $repo" >&2
        exit 1
    end
    ln -s "$repo" "$live"
    if test (readlink -f "$live") != "$repo"
        echo "Symlink verification failed for $live" >&2
        exit 1
    end
    echo "LINKED  $live -> $repo"
end

echo "Migration complete. Backups: $backup_root"
