{ pkgs, lib, ... }:
let
  awwwExe = lib.getExe pkgs.awww;
in
{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile = {
          name = "docked-with-tablet";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              mode = "1920x1080@60.0010";
              scale = 1.25;
              transform = "normal";
            }
            {
              criteria = "HDMI-A-1";
              position = "1536,0";
              mode = "1920x1080@120.0000";
              scale = 1.0;
              transform = "normal";
            }
            {
              criteria = "Virtual-1";
              position = "3456,280";
              mode = "1280x800@59.910";
              scale = 1.0;
              transform = "normal";
            }
          ];
          exec = [ "${awwwExe} restore" ];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              mode = "1920x1080@60.0010";
              scale = 1.25;
              transform = "normal";
            }
            {
              criteria = "HDMI-A-1";
              position = "1536,0";
              mode = "1920x1080@120.0000";
              scale = 1.0;
              transform = "normal";
            }
          ];
          exec = [ "${awwwExe} restore" ];
        };
      }
      {
        profile = {
          name = "docked-dp";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              mode = "1920x1080@60.0010";
              scale = 1.25;
              transform = "normal";
            }
            {
              criteria = "DP-1";
              position = "1536,0";
              mode = "1920x1080@200.0000";
              scale = 1.0;
              transform = "normal";
            }
          ];
          exec = [ "${awwwExe} restore" ];
        };
      }
      {
        profile = {
          name = "undocked-with-tablet";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              mode = "1920x1080@60.0010";
              scale = 1.0;
              transform = "normal";
            }
            {
              criteria = "Virtual-1";
              position = "1920,280";
              mode = "1280x800@59.910";
              scale = 1.0;
              transform = "normal";
            }
          ];
          exec = [ "${awwwExe} restore" ];
        };
      }
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              position = "1920,0";
              mode = "1920x1080@60.0010";
              scale = 1.0;
              transform = "normal";
            }
          ];
          exec = [ "${awwwExe} restore" ];
        };
      }
    ];
  };
}
