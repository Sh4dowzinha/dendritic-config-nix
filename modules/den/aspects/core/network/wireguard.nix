{
  den.aspects.core.network.wireguard = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        wireguard-tools
      ];
    };

    persist.directories = [
      "/etc/wireguard/"
    ];
  };
}
