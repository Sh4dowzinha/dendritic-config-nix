{
  # Named `firewall-config` rather than `firewall` so it does not collide with
  # the `den.quirks.firewall` quirk attribute on `den.aspects.core.network`.
  den.aspects.core.network.firewall-config = {
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
              # Only replace table inet nixos-fw on reload; never flush external
              # tables such as Mullvad's table inet mullvad.
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
