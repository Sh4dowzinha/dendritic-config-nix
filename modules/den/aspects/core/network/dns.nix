{ lib, ... }:
{
  den.aspects.core.network.dns = {
    nixos = {
      services.resolved = {
        enable = true;
        settings.Resolve = {
          LLMNR = lib.mkDefault "false";
          MulticastDNS = lib.mkDefault "false";
          DNSSEC = lib.mkDefault "false";
          DNSOverTLS = lib.mkDefault "opportunistic";
          FallbackDNS = lib.mkDefault [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
            "2620:fe::fe#dns.quad9.net"
            "2620:fe::9#dns.quad9.net"
          ];
        };
      };
    };
  };
}
