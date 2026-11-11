{
  den.aspects.core.network.dns = {
    nixos = {
      services.resolved = {
        enable = true;
        settings.Resolve = {
          LLMNR = "false";
          MulticastDNS = "false";
          DNSSEC = "false";
          Domains = [ "~." ];
          DNSOverTLS = "false";
          FallbackDNS = [
            "9.9.9.9"
            "149.112.112.112"
            "2620:fe::fe"
            "2620:fe::9"
          ];
        };
      };
    };
  };
}
