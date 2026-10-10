{
  den.aspects.core.network.wireguard = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        wireguard-tools
      ];
    };
  };
}
