{
  den.aspects.core.network.firewall = {
    nixos = {
      networking.firewall.enable = true;
      networking.nftables.enable = true;
    };
  };
}
