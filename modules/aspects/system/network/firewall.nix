{
  den.aspects.firewall = {
    nixos = {
      networking = {
        nftables.enable = true;
        firewall.enable = true;
      };
    };
  };
}
