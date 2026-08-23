{
  den.aspects.pipewire = {
    nixos = {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        audio.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        pulse.enable = true;
      
        wireplumber = {
          enable = true;
        };
      };
    };
    
    preservation-user-class = {
      directories = [
        ".local/state/wireplumber"
      ];
    };
  };
}
