{ ... }:
{
  nixos.boot =
    { pkgs, lib, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
        kernel.sysctl = {
          # network related
          "net.core.default_qdisc" = "fq";
          "net.ipv4.tcp_congestion_control" = "bbr";
          # security
          "kernel.unprivileged_bpf_disabled" = 1;
          "net.core.bpf_jit_harden" = 2;
          "kernel.dmesg_restrict" = 1;
          "kernel.kptr_restrict" = 2;
          "fs.protected_hardlinks" = 1;
          "fs.protected_symlinks" = 1;
          "fs.protected_fifos" = 2;
          "fs.protected_regular" = 2;
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
        extraModprobeConfig = ''
          # security
          install algif_aead /bin/false
        '';
        tmp.useTmpfs = true;
        tmp.cleanOnBoot = true;
        kernelParams = [
          "quiet"
          "loglevel=3"
          "systemd.show_status=auto"
          "rd.udev.log_level=3"
          "nowatchdog"
          "zswap.enabled=1"
          "dyndbg=\"func fw_log_firmware_info +p\""
          "initcall_blacklist=init_ima"
        ];
      };

      zramSwap = {
        enable = true;
        memoryPercent = 50;
      };
    };
}
