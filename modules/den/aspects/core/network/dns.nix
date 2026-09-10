{
  den.aspects.core.network.dns = {
    nixos = {
      networking.nameservers = [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      services.resolved = {
        enable = true;
        settings.Resolve = {
          LLMMR = "false";
          MulticastDNS = "false";
          DNSSEC = "true";
          Domains = [ "~." ];
          DNSOverTLS = "true";
          FallbackDNS = [
            "1.1.1.1"
            "1.0.0.1"
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
          ];
        };
      };
    };
  };
}
