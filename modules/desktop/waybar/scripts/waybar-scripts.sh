#!/bin/sh

termwin() {
  footclient fish -c "$1"
}

mic_icon() {
  if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q MUTED; then
    echo "󰍭 muted"
  else
    echo ""
  fi
}

do_not_disturb() {
  if makoctl mode 2>/dev/null | grep -q dnd; then
    printf "󰂛\nPress Mod+Shift+B\n"
  else
    echo ""
  fi
}

copy_date() {
  d="$(date '+%F')"
  if printf '%s' "$d" | wl-copy -n; then
    notify-send -a Waybar -r 9326 -i clipit-trayicon -t 5000 "date copied to clipboard!" "'$d'"
  else
    notify-send -a Waybar -r 9326 -i clipit-trayicon -t 5000 "something happened while copying date to clipboard." "check the script file $0."
  fi
}

gpu_usage() {
  usage=""
  for f in /sys/class/drm/card*/device/gpu_busy_percent /sys/class/hwmon/hwmon*/device/gpu_busy_percent; do
    if [ -r "$f" ]; then
      usage=$(cat "$f" 2>/dev/null)
      break
    fi
  done
  usage="${usage:-0}"
  printf '󰹑 <span foreground="%s">%s%%</span>\n' "$matugen_on_surface" "$usage"
}

bt_toggle() {
  if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    bluetoothctl power off
  else
    bluetoothctl power on
  fi
}

switch_audio_sink() {
  current_name=$(wpctl inspect @DEFAULT_SINK@ 2>/dev/null | grep "node.name" | awk -F '"' '{print $2}')
  if [ -z "$current_name" ]; then
    current_name=$(wpctl status 2>/dev/null | grep -A 5 "Default Configured Devices" | grep "Audio/Sink" | awk '{print $NF}')
  fi

  next=$(pw-dump Node 2>/dev/null | jq -r --arg cur "$current_name" '
          [ .[] | select(.info.props."media.class" == "Audio/Sink") | { name: .info.props."node.name", desc: .info.props."node.description", id: .id } ]
          | if length <= 1 then empty
            else
              (map(.name) | index($cur)) as $idx
              | if $idx == null then .[0]
                else .[($idx + 1) % length]
                end
            end
          | "\(.id)\t\(.desc)"
        ')

  if [ -n "$next" ]; then
    next_id=$(printf '%s' "$next" | cut -f1)
    next_desc=$(printf '%s' "$next" | cut -f2-)
    wpctl set-default "$next_id"
    notify-send -a Pipewire -r 9830 -i soundcard "audio output" "switched to: $next_desc"
  fi
}

case "$1" in
mic_icon)
  mic_icon
  ;;
do_not_disturb)
  do_not_disturb
  ;;
switch_audio_sink)
  switch_audio_sink
  ;;
sync_icon_click)
  termwin 'watch -c -n 0.5 easyclone get-status'
  ;;
gpu_click)
  termwin radeontop
  ;;
copy_date)
  copy_date
  ;;
gpu_usage)
  gpu_usage
  ;;
htop_cpu)
  termwin 'htop -t --sort-key PERCENT_CPU'
  ;;
htop_mem)
  termwin 'htop -t --sort-key PERCENT_MEM'
  ;;
bt_toggle)
  bt_toggle
  ;;
*)
  echo "Don't use this script from your terminal."
  ;;

esac
