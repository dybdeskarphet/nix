{ ... }:
{
  home.gui =
    {
      pkgs,
      colors,
      helpers,
      ...
    }:
    let
      waybar-scripts = pkgs.writeScriptBin "waybar-scripts" (
        builtins.readFile ./scripts/waybar-scripts.sh
      );
    in
    {
  # Packages & Styling {{{
  home.packages = with pkgs; [
    waybar-scripts
    pipewire
    wireplumber
    jq
    libnotify
    wl-clipboard
    bluez
    radeontop
    impala
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = ''
      ${helpers.colors.toCssDefineColors colors}

      ${builtins.readFile ./style.css}
    '';
    # }}}

    settings.mainBar = {
      # Bar Layout {{{
      position = "top";
      height = 24;
      spacing = 0;
      reload_style_on_change = true;

      "group/cpuntemp" = {
        orientation = "horizontal";
        modules = [
          "cpu"
          "temperature#cpu"
        ];
      };

      modules-right = [
        "tray"
        "custom/dnd"
        "custom/mic"
        "group/pulseaudionslider"
        "group/backlightnslider"
        "bluetooth"
        "network#wireless"
        "network#ethernet"
        "niri/workspaces"
      ];

      modules-center = [
        "niri/window"
      ];

      modules-left = [
        "clock"
        "battery"
        "group/cpuntemp"
        "custom/gpu_usage"
        "memory"
        "disk"
        "privacy"
      ];

      "group/pulseaudionslider" = {
        orientation = "horizontal";
        modules = [
          "pulseaudio"
          "pulseaudio/slider"
        ];
      };

      "group/backlightnslider" = {
        orientation = "horizontal";
        modules = [
          "backlight"
          "backlight/slider"
        ];
      };
      # }}}

      # Modules {{{
      clock = {
        locale = "tr_TR.UTF-8";
        format = "<span font_desc='Robot_Font 14' weight='700'>{:%H:%M}</span>";
        interval = 1;
        format-alt = "{:L%H:%M:%S  │ %F │ %B │ %A}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        on-click-right = "waybar-scripts copy_date";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='${colors.on_background}'><b>{}</b></span>";
            days = "<span color='${colors.on_background}'><b>{}</b></span>";
            weeks = "<span color='${colors.on_secondary_container}'><b>W{}</b></span>";
            weekdays = "<span color='${colors.on_secondary_container}'><b>{}</b></span>";
            today = "<span bgcolor='${colors.on_secondary_container}' color='#000000'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-middle = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      battery = {
        bat = "BAT0";
        interval = 20;
        states = {
          warning = 30;
          critical = 15;
        };
        format = ''{icon} <span foreground="${colors.on_background}">{capacity}%</span>'';
        format-charging = "{icon}󱐋 {capacity}%";
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        max-length = 25;
        tooltip = true;
        tooltip-format = "Time: {time} left\nCapacity: {health}%\n{power} watts";
      };

      cpu = {
        interval = 2;
        format = '' <span foreground="${colors.on_background}">{usage}%</span>'';
        max-length = 10;
        tooltip = true;
        on-click = "waybar-scripts htop_cpu";
      };

      memory = {
        interval = 2;
        format = '' <span foreground="${colors.on_background}">{}%</span>'';
        tooltip = true;
        tooltip-format = "{used:0.1f}GiB used\n{avail:0.1f}GiB available";
        max-length = 10;
        on-click = "waybar-scripts htop_mem";
      };

      "temperature#cpu" = {
        hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
        input-filename = "temp1_input";
        critical-threshold = 90;
        interval = 2;
        format-critical = " {temperatureC}°C";
        format = '' <span foreground="${colors.on_background}">{temperatureC}°C</span>'';
        on-click = "waybar-scripts htop_cpu";
      };

      disk = {
        interval = 60;
        format = ''󰋊 <span foreground="${colors.on_background}">{percentage_used}%</span>'';
        tooltip = true;
        tooltip-format = "Free: {free} ({percentage_free}%)\nTotal: {total}";
        path = "/";
      };

      "custom/dnd" = {
        exec = "waybar-scripts do_not_disturb";
        on-click = "makoctl mode -r dnd && pkill -RTMIN+4 waybar";
        signal = 4;
      };

      "custom/mic" = {
        exec = "waybar-scripts mic_icon";
        on-click = "volumectl -m toggle-mute && pkill -RTMIN+5 waybar";
        tooltip = false;
        signal = 5;
      };

      "custom/gpu_usage" = {
        format = ''󰹑 <span foreground="${colors.on_surface}">{}%</span>'';
        exec = "waybar-scripts gpu_usage";
        on-click = "waybar-scripts gpu_click";
        restart-interval = 4;
        tooltip = false;
      };

      "niri/workspaces" = {
        format = "{icon}";
        move-to-monitor = true;
      };

      "network#wireless" = {
        interface = "wlan0";
        interval = 2;
        format = "{ifname}";
        format-wifi = ''{signalStrength} 󰤨 <span foreground="${colors.on_secondary_container}"></span> <span foreground="${colors.on_background}">{bandwidthDownBytes}</span>  <span foreground="${colors.on_secondary_container}"></span> <span foreground="${colors.on_background}">{bandwidthUpBytes}</span>'';
        format-disconnected = "󰤭 Disconnected";
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-wifi = "SSID: {essid}\nIP: {ipaddr}";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
      };

      "network#ethernet" = {
        interface = "enp1s0";
        interval = 2;
        format = "{ifname}";
        format-ethernet = ''󰈁 <span foreground="${colors.on_secondary_container}"></span> <span foreground="${colors.on_background}">{bandwidthDownBytes}</span>  <span foreground="${colors.on_secondary_container}"></span> <span foreground="${colors.on_background}">{bandwidthUpBytes}</span>'';
        format-disconnected = "";
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-ethernet = "IP Address: {ipaddr}/{gwaddr}\nInterface: {ifname}";
        tooltip-format-disconnected = "";
        max-length = 50;
      };

      bluetooth = {
        format = ''󰂯 <span foreground="${colors.on_background}">{status}</span>'';
        format-on = "󰂯 No connection";
        format-disabled = "󰂯 Disabled";
        format-off = "󰂯 Disabled";
        on-click = "blueman-manager";
        on-click-right = "waybar-scripts bt_toggle";
        max-length = 15;
        format-connected = ''{device_battery_percentage} 󰂱 <span foreground="${colors.on_background}">{device_alias}</span>'';
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}:  {controller_address}\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}:  {device_address}";
      };

      backlight = {
        format = "{percent} {icon}";
        format-icons = [
          "󰃞"
          "󰃟"
          "󰃝"
          "󰃠"
        ];
        on-click = "nwg-displays";
        tooltip = false;
        device = "amdgpu_bl1";
      };

      "backlight/slider" = {
        min = 0;
        max = 100;
        orientation = "horizontal";
        device = "amdgpu_bl1";
      };

      pulseaudio = {
        format = "{volume} {icon}";
        format-bluetooth = "{volume} {icon}<span size='small'></span>";
        tooltip = true;
        tooltip-format = "{desc}";
        format-muted = "󰝟";
        format-icons = {
          combined-output = "󰴸";
          "combined-output.muted" = "󰓄";
          "alsa_output.usb-KTMICRO_JBL_TUNE_310C_USB-C_2020-02-20-0000-0000-0000-00.analog-stereo" = "󱡏";
          "alsa_output.usb-KTMICRO_JBL_TUNE_310C_USB-C_2020-02-20-0000-0000-0000-00.analog-stereo.muted" = "󱡐";
          headphone = "󰋋";
          hands-free = "󰋎";
          headset = "󰋎";
          phone = "";
          phone-muted = "";
          portable = "";
          car = "";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        scroll-step = 1;
        on-click-right = "pavucontrol";
        on-click = "waybar-scripts switch_audio_sink";
        ignored-sinks = [
          "Easy Effects Sink"
        ];
      };

      "pulseaudio/slider" = {
        min = 0;
        max = 120;
        orientation = "horizontal";
      };

      privacy = {
        icon-spacing = 4;
        icon-size = 12;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "audio-in";
            tooltip = true;
            tooltip-icon-size = 24;
          }
        ];
      };

      tray = {
        icon-size = 15;
        spacing = 10;
      };

      "niri/window" = {
        format = "{}";
        separate-outputs = true;
        max-length = 20;
      };
      # }}}
    };
  };
    };
}

# -- vim: fdm=marker fdl=0
