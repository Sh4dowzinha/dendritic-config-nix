{
  den.aspects.core.network.firewall = {
    nixos =
      {
        firewall ? [ ],
        lib,
        ...
      }:
      lib.mkMerge (
        [
          {
            networking.nftables = {
              enable = true;
              # Only replace table inet nixos-fw on reload; never flush external tables
              flushRuleset = false;
            };

            networking.firewall = {
              enable = true;

              # "loose" avoids dropping fwmark-routed VPN packets
              # while still rejecting spoofed source addresses.
              checkReversePath = "loose";

              # Avoid journal spam on noisy public WLANs
              logRefusedConnections = false;
              logRefusedPackets = false;

              # Silently drop unsolicited packets rather than sending RST/ICMP rejections
              rejectPackets = false;
            };
          }
        ]
        ++ lib.flatten firewall
      );
  };
}
