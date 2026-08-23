{
  den.aspects.dns = {
    nixos = {
      networking.nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];

      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNSSEC = "true";
          Domains = [ "~." ];
          DNSOverTLS = "true";
          MulticastDNS = "no";
          LLMNR = "no";
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
