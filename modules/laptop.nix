{ ... }:
{
  # Laptop Power & Lid {{{
  nixos.laptop =
    { ... }:
    {
      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
      };

      services.upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate"; # or "PowerOff" / "Suspend"
      };

      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          # cpu
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          # wireless
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "off";

          # audio
          SOUND_POWER_SAVE_ON_AC = 1;
          SOUND_POWER_SAVE_ON_BAT = 1;

          # pcie / usb
          RUNTIME_PM_DRIVER_DENYLIST = "";
          USB_EXCLUDE_PHONE = 1;
        };
      };
    };
  # }}}

  # Tmux Battery Status {{{
  home.laptop =
    { lib, colors, ... }:
    {
      programs.tmux.extraConfig = lib.mkAfter ''
        set -ga status-right " #[fg=${colors.tertiary_container},bg=default,bold]#[fg=${colors.on_tertiary_container},bg=${colors.tertiary_container},bold]󰁹 #(cat /sys/class/power_supply/BAT0/capacity)%%#[fg=${colors.tertiary_container},bg=default,bold]"
      '';
    };
  # }}}
}

# -- vim: fdm=marker fdl=0
