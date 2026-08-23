{
  den.aspects.steam = {
    nixos = { pkgs, ... }: {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      
      programs.gamemode.enable = true;
      
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
    
    preservation-user-class = {
      directories = [
        ".local/share/Steam"
      ];
    };
  };
}
