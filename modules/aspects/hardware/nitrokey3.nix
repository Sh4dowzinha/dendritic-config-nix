{
  den.aspects.nitrokey3.nixos = { pkgs, ... }: {
    hardware.nitrokey.enable = true;
    
    environment.systemPackages = with pkgs; [
      nitrokey-app2
      pynitrokey
    ];
  };
}
