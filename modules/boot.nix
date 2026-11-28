{ ... }:
{
  nixos.boot =
    { pkgs, lib, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
        consoleLogLevel = 3;
        kernel.sysctl = {
          # network
          "net.core.default_qdisc" = "fq";
          "net.ipv4.tcp_congestion_control" = "bbr";
          # zram
          "vm.swappiness" = 180;
          "vm.watermark_boost_factor" = 0;
          "vm.watermark_scale_factor" = 125;
          "vm.page-cluster" = 0;
          # security
          "kernel.unprivileged_bpf_disabled" = 1;
          "net.core.bpf_jit_harden" = 2;
          "kernel.dmesg_restrict" = 1;
          "kernel.kptr_restrict" = 2;
          "kernel.yama.ptrace_scope" = 1;
        };
        loader = {
          systemd-boot = {
            enable = lib.mkDefault true;
            configurationLimit = 10;
            editor = false;
            memtest86.enable = true;
          };
          efi.canTouchEfiVariables = true;
          timeout = 0;
        };
        tmp.useTmpfs = true;
        kernelParams = [
          "quiet"
          "systemd.show_status=auto"
          "rd.udev.log_level=3"
          "nowatchdog"
          "zswap.enabled=0"
          "initcall_blacklist=init_ima"
        ];
      };

      zramSwap = {
        enable = true;
        memoryPercent = 50;
      };
    };
}
