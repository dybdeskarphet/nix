{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        grace = 0;
        disable_loading_bar = false;
      };

      background = [
        {
          monitor = "HDMI-A-1";
          path = "${./images/lock_wall.png}";
          blur_passes = 0;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
        {
          monitor = "eDP-1";
          path = "${./images/lock_wall.png}";
          blur_passes = 0;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
        {
          monitor = "Virtual-1";
          path = "${./images/lock_wall.png}";
          blur_passes = 0;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      image = [
        {
          monitor = "";
          path = "${./images/profile.jpeg}";
          border_size = 2;
          border_color = "rgba(255, 255, 255, .75)";
          size = 95;
          rounding = -1;
          rotate = 0;
          reload_time = -1;
          reload_cmd = "";
          position = "270, 25";
          halign = "left";
          valign = "center";
        }
      ];

      shape = [
        {
          monitor = "";
          size = "320, 55";
          color = "rgba(255, 255, 255, .1)";
          rounding = -1;
          border_size = 0;
          border_color = "rgba(255, 255, 255, 1)";
          rotate = 0;
          xray = false;
          position = "160, -140";
          halign = "left";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "Welcome!";
          color = "rgba(216, 222, 233, .75)";
          font_size = 55;
          font_family = "proportional_font";
          position = "152, 320";
          halign = "left";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span>$(date +\"%H:%M\")</span>\"";
          color = "rgba(216, 222, 233, .75)";
          font_size = 40;
          font_family = "proportional_font";
          position = "247, 240";
          halign = "left";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
          color = "rgba(216, 222, 233, .75)";
          font_size = 19;
          font_family = "proportional_font";
          position = "199, 175";
          halign = "left";
          valign = "center";
        }
        {
          monitor = "";
          text = "    $USER";
          color = "rgba(216, 222, 233, 0.80)";
          font_size = 16;
          font_family = "proportional_font";
          position = "260, -140";
          halign = "left";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[] printf '"First a warning, musical;\nthen the hour, irrevocable.\nThe leaden circles dissolved in the air."\n— Virginia Woolf, Mrs. Dalloway' '';
          color = "rgba(255, 255, 255, 0.65)";
          text_align = "center";
          font_size = 14;
          font_family = "proportional_font";
          position = "150, 45";
          valign = "bottom";
          halign = "left";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "320, 55";
          outline_thickness = 0;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(255, 255, 255, 0)";
          inner_color = "rgba(255, 255, 255, 0.1)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          font_family = "proportional_font";
          placeholder_text = ''<i><span foreground="##ffffff99">    Enter Password </span></i>'';
          hide_input = false;
          position = "160, -220";
          halign = "left";
          valign = "center";
        }
      ];
    };
  };
}
