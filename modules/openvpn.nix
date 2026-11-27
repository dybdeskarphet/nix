{ ... }:
{
  nixos.openvpn =
    {
      pkgs,
      lib,
      env,
      ...
    }:
    let
      profiles = env.openvpn.profiles or [ ];
      configDir = "/run/secrets/openvpn";
      resolvedScript = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";
    in
    {
      sops.secrets = lib.listToAttrs (
        map (
          name:
          lib.nameValuePair "openvpn/${name}.ovpn" {
            key = "openvpn/${name}";
            mode = "0400";
          }
        ) profiles
      );

      boot.kernelModules = [ "tun" ];

      environment.systemPackages = [ pkgs.openvpn ];

      systemd.services."openvpn@" = {
        description = "OpenVPN connection for %i";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        unitConfig.ConditionPathExists = "${configDir}/%i.ovpn";

        path = [
          pkgs.iptables
          pkgs.iproute2
          pkgs.net-tools
        ];

        serviceConfig = {
          Type = "notify";
          WorkingDirectory = configDir;
          ExecStart = lib.concatStringsSep " " [
            "${pkgs.openvpn}/sbin/openvpn"
            "--suppress-timestamps"
            ''--config "${configDir}/%i.ovpn"''
            "--script-security 2"
            "--up ${resolvedScript}"
            "--down ${resolvedScript}"
            "--down-pre"
          ];
          Restart = "no";
        };
      };
    };
}
