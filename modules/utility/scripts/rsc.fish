set -l _sudo
if not fish_is_root_user
    set _sudo sudo
end

set -l cmd $argv[1]
set -e argv[1]

switch $cmd
    # 1. Snapshots & Files
    case snap snapshots
        $_sudo restic-cloud-backup snapshots $argv

    case last latest
        $_sudo restic-cloud-backup snapshots --latest 3 $argv

    case ls
        set -l snap_id latest
        test (count $argv) -gt 0; and set snap_id $argv[1]
        $_sudo restic-cloud-backup ls $snap_id

    case find search
        if test (count $argv) -eq 0
            echo (set_color yellow)"Usage: rsc find <pattern>"(set_color normal)
            exit 1
        end
        $_sudo restic-cloud-backup find $argv

    case diff
        if test (count $argv) -lt 2
            echo (set_color yellow)"Usage: rsc diff <snapshot-id-1> <snapshot-id-2>"(set_color normal)
            exit 1
        end
        $_sudo restic-cloud-backup diff $argv[1] $argv[2]

    case stats
        $_sudo restic-cloud-backup stats --mode raw-data $argv

    case check
        echo (set_color blue)"Checking repository (5% blob subset)..."(set_color normal)
        $_sudo restic-cloud-backup check --read-data-subset=5% $argv

    case unlock
        $_sudo restic-cloud-backup unlock $argv

    case mount
        set -l mnt_path /tmp/restic-mount
        test (count $argv) -gt 0; and set mnt_path $argv[1]
        mkdir -p $mnt_path
        echo (set_color green)"Mounting repo at $mnt_path (Ctrl+C or unmount to exit)..."(set_color normal)
        $_sudo restic-cloud-backup mount $mnt_path

    case status
        systemctl status restic-backups-cloud-backup.service

    case timers timer
        systemctl list-timers 'restic*'

    case log logs
        journalctl -u restic-backups-cloud-backup.service -n 50 -e

    case run now
        echo (set_color yellow)"Triggering cloud-backup systemd service..."(set_color normal)
        $_sudo systemctl start restic-backups-cloud-backup.service

    case help ""
        echo (set_color cyan --bold)"Restic Quick Commands:"(set_color normal)
        echo "  "(set_color green)"rsc last"(set_color normal)"        Show 3 most recent snapshots"
        echo "  "(set_color green)"rsc snap"(set_color normal)"        List all snapshots"
        echo "  "(set_color green)"rsc ls [id]"(set_color normal)"     List files in a snapshot (defaults to latest)"
        echo "  "(set_color green)"rsc find <term>"(set_color normal)" Search for a file across snapshots"
        echo "  "(set_color green)"rsc diff <id1> <id2>"(set_color normal)" Compare two snapshots"
        echo "  "(set_color green)"rsc stats"(set_color normal)"       Show repo storage usage & deduplication"
        echo "  "(set_color green)"rsc check"(set_color normal)"       Verify repo integrity (fast 5% check)"
        echo "  "(set_color green)"rsc mount [dir]"(set_color normal)" Mount snapshots to browse via file manager"
        echo "  "(set_color green)"rsc unlock"(set_color normal)"      Clear stale locks"
        echo "  "(set_color cyan)"rsc timers"(set_color normal)"      Check systemd timer countdown"
        echo "  "(set_color cyan)"rsc status"(set_color normal)"      Check systemd backup service status"
        echo "  "(set_color cyan)"rsc log"(set_color normal)"         View last 50 lines of backup logs"
        echo "  "(set_color cyan)"rsc run"(set_color normal)"         Run backup now via systemd"

    case '*'
        $_sudo restic-cloud-backup $cmd $argv
end
