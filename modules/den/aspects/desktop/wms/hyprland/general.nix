{
  den.aspects.desktop.hyprland = {
    homeManager.wayland.windowManager.hyprland = {
      settings = {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            resize_on_border = true;
            no_focus_fallback = true;
            allow_tearing = false; # For now at least

            col = {
              active_border = "rgba(0DB7D455)";
              inactive_border = "rgba(31313600)";
            };

            snap = {
              enabled = true;
              window_gap = 4;
              monitor_gap = 5;
              respect_gaps = true;
            };
          };

          decoration = {
            rounding_power = 2.5;
            rounding = 18;

            dim_inactive = true;
            dim_strength = 0.05;
            dim_special = 0.2;

            blur = {
              enabled = true;
              xray = true;
              special = false;
              new_optimizations = true;
              size = 10;
              passes = 3;
              brightness = 1;
              noise = 0.05;
              contrast = 0.89;
              vibrancy = 0.5;
              vibrancy_darkness = 0.5;
              popups = false;
              popups_ignorealpha = 0.6;
              input_methods = true;
              input_methods_ignorealpha = 0.8;
            };

            shadow = {
              enabled = true;
              range = 20;
              offset = "0 2";
              render_power = 3;
              color = "rgba(00000020)";
            };
          };

          animations = {
            enabled = true;
          };

          dwindle = {
            preserve_split = true;
            smart_split = false;
            smart_resizing = false;
          };
        };
      };
    };
  };
}
