export LC_ALL=C.UTF-8

RST=$'\e[0m'
BOLD=$'\e[1m'
RED=$'\e[31m'
GRN=$'\e[32m'
MAG=$'\e[35m'
CYN=$'\e[36m'
WHT=$'\e[37m'

HOST="$(uname -n)"
KERNEL="$(uname -r)"
GEN="$(basename "$(readlink /nix/var/nix/profiles/system 2>/dev/null || echo system-0-link)" | sed -E 's/system-([0-9]+)-link/\1/')"
NOW="$(date '+%Y-%m-%d %H:%M')"
TTY_NAME="$(tty 2>/dev/null | sed 's|^/dev/||' || echo tty1)"
FAILED="$(systemctl --failed --no-legend 2>/dev/null | wc -l | tr -d ' ')"

BAT_COL=""
if [ "${SHOW_BATTERY:-0}" = "1" ] && [ -r /sys/class/power_supply/BAT0/capacity ]; then
  bat_val="$(cat /sys/class/power_supply/BAT0/capacity)%"
  BAT_COL=" ${CYN}•${RST} ${WHT}${bat_val}${RST}"
fi

if [ "${FAILED:-0}" -eq 0 ]; then
  health_col="${GRN}0 failed${RST}"
else
  health_col="${RED}${FAILED} failed${RST}"
fi

printf '\e%%G\e[2J\e[H\n'
printf '  %s ▄████▀  %s██████▀  %s  ▄█▄    %s██████▄  %s██████▄  %s█▄   ▄█  %s███      %s███████%s\n' \
  "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"
printf '  %s▀████▄   %s████▀    %s ▄███▄   %s███████  %s███████  %s███▄███  %s█████    %s▀▀███▀▀%s\n' \
  "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"
printf '  %s ▄████▀  %s█████▄   %s▄█████▄  %s██████   %s████▀▀   %s██▀ ▀██  %s███████  %s  ███  %s\n' \
  "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"
printf '  %s▀▀▀▀▀    %s▀▀▀▀▀▀▀  %s▀▀▀▀▀▀▀  %s▀▀▀▀▀▀▀  %s▀▀▀▀     %s▀     ▀  %s▀▀▀▀▀▀▀  %s  ▀▀▀  %s\n' \
  "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "${BOLD}${MAG}" "${BOLD}${GRN}" "$RST"

printf '\n  %s──────────────────────────────────────────────────────────────────────%s\n' "$CYN" "$RST"
printf '  %s%s%s %s•%s %sgen #%s%s %s•%s %s%s%s%s %s•%s %s %s•%s %s%s%s %s• %s%s\n\n' \
  "${BOLD}${WHT}" "$HOST" "$RST" "$CYN" "$RST" "$MAG" "$GEN" "$RST" "$CYN" "$RST" \
  "$WHT" "${KERNEL%%-*}" "$RST" "$BAT_COL" "$CYN" "$RST" "$health_col" "$CYN" "$RST" \
  "$WHT" "$NOW" "$RST" "$CYN" "$TTY_NAME" "$RST"

exec login "$@"
