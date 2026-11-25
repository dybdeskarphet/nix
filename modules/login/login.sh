export LC_ALL=C.UTF-8

RST=$'\e[0m'
BOLD=$'\e[1m'
DIM=$'\e[2m'
RED=$'\e[31m'
GRN=$'\e[32m'
MAG=$'\e[35m'
CYN=$'\e[36m'
WHT=$'\e[37m'

LINES_N=0
COLS=0
if read -r r c < <(stty -F /dev/tty size 2>/dev/null); then
  LINES_N="$r"
  COLS="$c"
fi
if [ "${LINES_N:-0}" -le 24 ] && [ "${COLS:-0}" -le 80 ] && [ -r /dev/tty ] && [ -w /dev/tty ]; then
  old_stty="$(stty -F /dev/tty -g 2>/dev/null || true)"
  stty -F /dev/tty raw -echo min 0 time 2 2>/dev/null || true
  printf '\e[999;999H\e[6n' > /dev/tty
  IFS='[;' read -r -t 1 -d R _ dsr_r dsr_c < /dev/tty 2>/dev/null || true
  if [ -n "$old_stty" ]; then
    stty -F /dev/tty "$old_stty" 2>/dev/null || true
  fi
  if [ "${dsr_r:-0}" -gt 0 ] 2>/dev/null && [ "${dsr_c:-0}" -gt 0 ] 2>/dev/null; then
    LINES_N="$dsr_r"
    COLS="$dsr_c"
  fi
fi
if [ "${LINES_N:-0}" -le 0 ]; then LINES_N=24; fi
if [ "${COLS:-0}" -le 0 ]; then COLS=80; fi

HOST="$(uname -n)"
KERNEL="$(uname -r)"
GEN="$(basename "$(readlink /nix/var/nix/profiles/system 2>/dev/null || echo system-0-link)" | sed -E 's/system-([0-9]+)-link/\1/')"
NOW="$(date '+%Y-%m-%d %H:%M')"
TTY_NAME="$(tty 2>/dev/null | sed 's|^/dev/||' || echo tty1)"
FAILED="$(systemctl --failed --no-legend 2>/dev/null | wc -l | tr -d ' ')"

BAT_RAW=""
BAT_COL=""
if [ -r /sys/class/power_supply/BAT0/capacity ]; then
  bat_val="$(cat /sys/class/power_supply/BAT0/capacity)%"
  BAT_RAW=" · ${bat_val}"
  BAT_COL=" ${DIM}·${RST} ${CYN}${bat_val}${RST}"
fi

center_line() {
  local raw="$1" colored="$2"
  local pad=$(( (COLS - ${#raw}) / 2 ))
  if [ "$pad" -lt 0 ]; then pad=0; fi
  printf '%*s%s\n' "$pad" "" "$colored"
}

printf '\e[2J\e[H'

pad_top=$(( (LINES_N - 10) / 2 ))
if [ "$pad_top" -lt 1 ]; then pad_top=1; fi
for ((i = 0; i < pad_top; i++)); do printf '\n'; done

logo_pad=$(( (COLS - 70) / 2 ))
if [ "$logo_pad" -lt 0 ]; then logo_pad=0; fi

printf '%*s%s ▄████▀  %s██████▀  %s  ▄█▄    %s██████▄  %s██████▄  %s█▄   ▄█  %s███      %s███████%s\n' \
  "$logo_pad" "" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"
printf '%*s%s▀████▄   %s████▀    %s ▄███▄   %s███████  %s███████  %s███▄███  %s█████    %s▀▀███▀▀%s\n' \
  "$logo_pad" "" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"
printf '%*s%s ▄████▀  %s█████▄   %s▄█████▄  %s██████   %s████▀▀   %s██▀ ▀██  %s███████  %s  ███  %s\n' \
  "$logo_pad" "" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"
printf '%*s%s▀▀▀▀▀    %s▀▀▀▀▀▀▀  %s▀▀▀▀▀▀▀  %s▀▀▀▀▀▀▀  %s▀▀▀▀     %s▀     ▀  %s▀▀▀▀▀▀▀  %s  ▀▀▀  %s\n' \
  "$logo_pad" "" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"

printf '\n'
rule="──────────────────────────────────────────────────────────────────────"
center_line "$rule" "${DIM}${CYN}${rule}${RST}"

if [ "${FAILED:-0}" -eq 0 ]; then
  health_raw="0 failed"
  health_col="${GRN}0 failed${RST}"
else
  health_raw="${FAILED} failed"
  health_col="${RED}${FAILED} failed${RST}"
fi

meta_raw="${HOST} · gen #${GEN} · ${KERNEL%%-*}${BAT_RAW} · ${health_raw} · ${NOW} · ${TTY_NAME}"
meta_col="${BOLD}${WHT}${HOST}${RST} ${DIM}·${RST} ${MAG}gen #${GEN}${RST} ${DIM}·${RST} ${WHT}${KERNEL%%-*}${RST}${BAT_COL} ${DIM}·${RST} ${health_col} ${DIM}·${RST} ${WHT}${NOW}${RST} ${DIM}· ${TTY_NAME}${RST}"
center_line "$meta_raw" "$meta_col"

printf '\n'
prompt_pad=$(( (COLS - 20) / 2 ))
if [ "$prompt_pad" -lt 0 ]; then prompt_pad=0; fi
printf '%*s' "$prompt_pad" ""

exec login "$@"
