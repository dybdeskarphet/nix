#!/usr/bin/env fish

set -l ENV_FILE "$HOME/.config/user-env.json"
set -l STATE_DIR (or $XDG_STATE_HOME "$HOME/.local/state")/borg
mkdir -p "$STATE_DIR"

set -l BACKUP_ITEMS
set -l BORG_REPO

if test -f "$ENV_FILE"
    set BACKUP_ITEMS (jq -r '.borg.items[]? // empty' "$ENV_FILE")
    set BORG_REPO (jq -r '.borg.repo // empty' "$ENV_FILE")
end

if test (count $BACKUP_ITEMS) -eq 0
    echo (set_color red)"No backup items found in $ENV_FILE."(set_color normal) >&2
    echo "Please configure 'borg.items' in your /etc/nixos/env.nix (or ~/.config/user-env.json)." >&2
    exit 1
end

if test -z "$BORG_REPO"
    echo (set_color red)"No Borg repository path configured in $ENV_FILE."(set_color normal) >&2
    echo "Please configure 'borg.repo' in your /etc/nixos/env.nix (or ~/.config/user-env.json)." >&2
    exit 1
end

# 1. Show backup info
set -l LAST_BACKUP_FILE "$STATE_DIR/last_backup"
if test -f "$LAST_BACKUP_FILE"
    echo "Last backup: "(set_color yellow)(cat "$LAST_BACKUP_FILE")(set_color normal)
end

echo "Backing up items:"
for item in $BACKUP_ITEMS
    echo "  - "(set_color cyan)$item(set_color normal)
end
echo ---------------------------------------------------

set ARCHIVE_NAME (hostname)-(date +%Y-%m-%d-%H%M%S)

set BORG_CMD borg
if not test -w "$BORG_REPO"
    echo "Repository '"(set_color cyan)$BORG_REPO(set_color normal)"' is not writable by current user. Using "(set_color yellow)"sudo"(set_color normal)"..."
    set BORG_CMD sudo borg
end

echo "Starting backup to "(set_color cyan)"$BORG_REPO::$ARCHIVE_NAME"(set_color normal)
echo ---------------------------------------------------

$BORG_CMD create \
    --verbose \
    --filter AME \
    --list \
    --stats \
    --show-rc \
    --compression lz4 \
    "$BORG_REPO::$ARCHIVE_NAME" \
    $BACKUP_ITEMS

set backup_status $status

echo ---------------------------------------------------
if test $backup_status -eq 0
    echo "Backup completed "(set_color green)"successfully!"(set_color normal)
    date "+%Y-%m-%d %H:%M:%S" > "$LAST_BACKUP_FILE"
    echo "success" > "$STATE_DIR/last_status"
else if test $backup_status -eq 1
    echo "Backup completed with "(set_color yellow)"warnings."(set_color normal)
    echo "warning" > "$STATE_DIR/last_status"
else
    echo "Backup failed with an "(set_color red)"error."(set_color normal)
    echo "failed" > "$STATE_DIR/last_status"
end

exit $backup_status
