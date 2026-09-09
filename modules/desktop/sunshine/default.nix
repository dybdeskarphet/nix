{ pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "nixos";
      audio_sink = "sunshine_sink";
      output_name = "Virtual-1";
      stream_audio = "disabled";
    };
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
      ];
    };
  };
}
