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

    case status runs history
        if test (count $argv) -gt 0; and contains -- "$argv[1]" --systemctl -s
            systemctl status restic-backups-cloud-backup.service
        else
            python3 -c '
import subprocess
import json
import datetime
import re
import sys
import argparse

def format_duration(seconds: float) -> str:
    if seconds < 0:
        return "0s"
    mins, secs = divmod(seconds, 60)
    hours, mins = divmod(mins, 60)
    if hours > 0:
        return f"{int(hours)}h {int(mins)}m {int(secs)}s"
    elif mins > 0:
        return f"{int(mins)}m {int(secs)}s"
    return f"{secs:.1f}s"

parser = argparse.ArgumentParser(description="Check restic backup run history and service status.", add_help=False)
parser.add_argument("-n", "--lines", type=int, default=10, help="Number of runs to show (default: 10)")
parser.add_argument("-a", "--all", action="store_true", help="Show all recorded runs")
parser.add_argument("-f", "--failed", action="store_true", help="Show only failed runs")
parser.add_argument("--success", action="store_true", help="Show only successful runs")
parser.add_argument("-S", "--since", type=str, default=None, help="Filter runs since date/time")
parser.add_argument("--no-color", action="store_true", help="Disable ANSI color codes")
parser.add_argument("-h", "--help", action="store_true", help="Show help")
parser.add_argument("limit_pos", nargs="?", type=int, default=None, help="Positional run count limit")

args, remaining = parser.parse_known_args()

if args.help:
    print("Usage: rsc status [options] [count]")
    print("\nOptions:")
    print("  -n, --lines <N>   Show last N runs (default: 10)")
    print("  -a, --all         Show all recorded runs")
    print("  -f, --failed      Show only failed runs")
    print("      --success     Show only successful runs")
    print("  -S, --since <T>   Filter entries since date (e.g. \"24 hours ago\", \"yesterday\")")
    print("  -s, --systemctl   View raw systemctl status output")
    print("      --no-color    Disable colored output")
    sys.exit(0)

limit = args.limit_pos if args.limit_pos is not None else args.lines
if args.all:
    limit = None

cmd = ["journalctl", "--no-pager", "-u", "restic-backups-cloud-backup.service", "-o", "json"]
if args.since:
    cmd.extend(["--since", args.since])

try:
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
except Exception as e:
    print(f"Error accessing journal: {e}", file=sys.stderr)
    sys.exit(1)

runs = []
curr = None

for line in proc.stdout:
    line = line.strip()
    if not line:
        continue
    try:
        e = json.loads(line)
    except:
        continue

    msg = e.get("MESSAGE", "")
    if not isinstance(msg, str):
        continue

    ts = int(e.get("__REALTIME_TIMESTAMP", 0)) / 1e6
    if not ts:
        continue

    if ("Starting " in msg or "Started " in msg) and curr is None:
        curr = {
            "start": ts,
            "end": None,
            "status": None,
            "snap": "-",
            "added": "-",
            "files": "-",
            "processed_time": None,
            "reason": "",
            "locked_pid": None
        }
    elif curr is not None:
        if "snapshot" in msg and "saved" in msg:
            m = re.search(r"snapshot\s+([0-9a-fA-F]+)\s+saved", msg)
            if m:
                curr["snap"] = m.group(1)[:8]
        if "Added to the repository:" in msg:
            m = re.search(r"Added to the repository:\s*([^,\(]+)", msg)
            if m:
                curr["added"] = m.group(1).strip()
        if "processed " in msg and " files" in msg:
            m = re.search(r"processed\s+(\d+)\s+files", msg)
            if m:
                curr["files"] = m.group(1)
            m_time = re.search(r"in\s+(\d+:\d+|\d+s)", msg)
            if m_time:
                curr["processed_time"] = m_time.group(1)
        if "repository is already locked" in msg or "repo already locked" in msg:
            curr["locked_pid"] = True
            m = re.search(r"locked by PID (\d+)", msg)
            if m:
                curr["locked_pid"] = m.group(1)
                curr["reason"] = f"Repo locked (PID {m.group(1)})"
            else:
                curr["reason"] = "Repo locked"

        if any(k in msg for k in ("Finished ", "Deactivated successfully", "Succeeded", "status=0/SUCCESS")):
            curr["status"] = "SUCCESS"
            if not curr["reason"]:
                curr["reason"] = "Finished normally"
            curr["end"] = ts
        elif any(k in msg for k in ("Stopped ", "Stopping ")):
            curr["status"] = "STOPPED"
            if not curr["reason"]:
                curr["reason"] = "Interrupted"
            curr["end"] = ts
        elif any(k in msg for k in ("Failed with result", "Failed to start")):
            curr["status"] = "FAILED"
            if not curr["reason"]:
                curr["reason"] = msg[:45]
            curr["end"] = ts

        if curr["status"] and curr["end"]:
            runs.append(curr)
            curr = None

try:
    active_proc = subprocess.run(["systemctl", "is-active", "restic-backups-cloud-backup.service"], capture_output=True, text=True)
    is_active = active_proc.stdout.strip() == "active"
except:
    is_active = False

if curr is not None and is_active:
    curr["status"] = "RUNNING"
    curr["end"] = datetime.datetime.now().timestamp()
    curr["reason"] = "In progress..."
    runs.append(curr)

next_timer = None
try:
    timer_proc = subprocess.run(["systemctl", "list-timers", "restic-backups-cloud-backup.timer", "--no-pager", "--full"], capture_output=True, text=True)
    for line in timer_proc.stdout.splitlines():
        if "restic-backups-cloud-backup" in line:
            m = re.search(r"^([A-Za-z]{3}\s+\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}(?:\s+[+-]\d+)?)\s+(\S+)", line.strip())
            if m:
                next_timer = f"{m.group(1)} ({m.group(2)} left)"
            break
except:
    pass

use_color = not args.no_color and sys.stdout.isatty()
C_GREEN = "\033[92m" if use_color else ""
C_RED = "\033[91m" if use_color else ""
C_YELLOW = "\033[93m" if use_color else ""
C_BLUE = "\033[94m" if use_color else ""
C_CYAN = "\033[96m" if use_color else ""
C_BOLD = "\033[1m" if use_color else ""
C_DIM = "\033[2m" if use_color else ""
C_RESET = "\033[0m" if use_color else ""

state_label = "RUNNING" if is_active else "IDLE"
status_color = C_BLUE if is_active else (C_GREEN if runs and runs[-1]["status"] == "SUCCESS" else C_RED)

print(f"{C_BOLD}{C_CYAN}=== Restic Cloud Backup Status & Run History ==={C_RESET}")
print(f"Service Unit : {C_BOLD}restic-backups-cloud-backup.service{C_RESET}")
print(f"Current State: {status_color}{C_BOLD}{state_label}{C_RESET}")
if next_timer:
    print(f"Next Run     : {C_BLUE}{next_timer}{C_RESET}")
print()

filtered_runs = runs
if args.failed:
    filtered_runs = [r for r in runs if r["status"] == "FAILED"]
elif args.success:
    filtered_runs = [r for r in runs if r["status"] == "SUCCESS"]

if not filtered_runs:
    print("No matching runs found in journal.")
    sys.exit(0)

display_runs = filtered_runs[-limit:] if (limit is not None and len(filtered_runs) > limit) else filtered_runs

t_start = "START TIME"
t_dur = "DURATION"
t_stat = "STATUS"
t_snap = "SNAPSHOT"
t_files = "FILES"
t_added = "ADDED"
t_details = "DETAILS / REASON"
hdr = f"{C_BOLD}{t_start:<19}  {t_dur:<9}  {t_stat:<9}  {t_snap:<8}  {t_files:<7}  {t_added:<11}  {t_details}{C_RESET}"
print(hdr)
print(C_DIM + "─" * 90 + C_RESET)

for r in display_runs:
    st_str = datetime.datetime.fromtimestamp(r["start"]).strftime("%Y-%m-%d %H:%M:%S")
    dur_str = format_duration(r["end"] - r["start"])
    st = r["status"]
    if st == "SUCCESS":
        col = C_GREEN
    elif st == "FAILED":
        col = C_RED
    elif st == "RUNNING":
        col = C_BLUE
    else:
        col = C_YELLOW

    snap = r["snap"]
    files = r["files"]
    added = r["added"]
    reason = r["reason"]

    print(f"{st_str:<19}  {dur_str:<9}  {col}{st:<9}{C_RESET}  {C_CYAN}{snap:<8}{C_RESET}  {files:<7}  {added:<11}  {reason}")

print(C_DIM + "─" * 90 + C_RESET)

successes = [r for r in runs if r["status"] == "SUCCESS"]
failures = [r for r in runs if r["status"] == "FAILED"]
total = len(runs)

rate = f"({len(successes)/total*100:.1f}%)" if total else ""
print(f"{C_BOLD}Summary Statistics:{C_RESET}")
print(f"  Total Runs Tracked : {C_BOLD}{total}{C_RESET}")
print(f"  Successful         : {C_GREEN}{len(successes)}{C_RESET} {rate}")
print(f"  Failed             : {C_RED}{len(failures)}{C_RESET}")
if successes:
    avg_dur = sum((r["end"] - r["start"]) for r in successes) / len(successes)
    print(f"  Avg Success Time   : {C_CYAN}{format_duration(avg_dur)}{C_RESET}")

if runs and runs[-1]["status"] == "FAILED" and runs[-1].get("locked_pid"):
    pid = runs[-1]["locked_pid"]
    pid_str = f"PID {pid}" if pid is not True else "another process"
    print()
    print(f"{C_YELLOW}💡 Note: Repository lock was encountered ({pid_str}).{C_RESET}")
    print(f"   Run {C_BOLD}rsc unlock{C_RESET} to clear stale locks.")
' $argv
        end

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
        echo "  "(set_color green)"rsc timers"(set_color normal)"      Check systemd timer countdown"
        echo "  "(set_color green)"rsc status [args]"(set_color normal)" Check backup run history & status in table format"
        echo "  "(set_color green)"rsc log"(set_color normal)"         View last 50 lines of backup logs"
        echo "  "(set_color green)"rsc run"(set_color normal)"         Run backup now via systemd"

    case '*'
        $_sudo restic-cloud-backup $cmd $argv
end
