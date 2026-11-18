{ ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8000
      8080
    ];
  };
}
