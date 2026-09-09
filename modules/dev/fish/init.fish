# if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
#     systemctl --user --wait start niri.service
#     systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
#     systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
#     exit
# end
