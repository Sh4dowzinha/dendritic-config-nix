{
  den.aspects.applications.network.localsend = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        localsend
      ];
    };

    firewall = {
      networking.firewall.allowedTCPPorts = [ 53317 ];
      networking.firewall.allowedUDPPorts = [ 53317 ];
    };
  };
}
