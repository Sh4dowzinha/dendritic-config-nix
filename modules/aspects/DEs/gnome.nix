{ den, ... }: {
  den.aspects.gnome = {
    includes = with den.aspects; [
      shell.fish
    ];
    
    nixos = {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      
      programs.dconf.enable = true;
    };
    
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        gnomeExtensions.caffeine
        gnomeExtensions.appindicator
      ];
      
      dconf.settings = {
        "org/gnome/Console" = {
          shell = [ "fish" ];
        };

        "org/gnome/desktop/interface" = {
          enable-hot-corners = true;
          color-scheme = "prefer-dark";
        };

        "org/gnome/shell" = {
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "caffeine@patapon.info" 
          ];
        };
      };
    };
    
    preservation-user-class = {
      directories = [
        ".local/share/keyrings"
      ];
    };
  };
}
