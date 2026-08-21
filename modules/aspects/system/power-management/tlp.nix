{
  den.aspects.tlp.nixos = {
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      pd.enable = true;
      
      settings = {
        USB_AUTOSUSPEND = 0;
      };
    };
  };
}

