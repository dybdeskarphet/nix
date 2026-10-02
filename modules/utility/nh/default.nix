{ config, ... }:
{
  programs.nh = {
    enable = true;
    flake = "${config.users.users.skarphet.home}/code/nix";
  };
}
