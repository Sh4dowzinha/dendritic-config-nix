{
  den,
  lib,
  rootPath,
  ...
}:
let
  inherit (lib) mkOption types;
  netLib = import (rootPath + "/modules/den/lib/_network.nix") { inherit den lib; };
in
{
  den.aspects.core.network.networkd = {
    settings = {
      vpnCompat = mkOption {
        type = types.bool;
        default = true;
        description = "Preserve foreign routes/policy rules and mark wg*/tun*/tap* unmanaged.";
      };
    };

    nixos =
      { host, lib, ... }:
      let
        netCfg = host.settings.core.network;
        cfg = netCfg.networkd;
        isNetworkd = netCfg.backend == "networkd";
        effectiveIgnoreDHCPDNS = netCfg.ignoreDHCPDNS || (netCfg.defaultDNS != [ ]);
      in
      lib.mkIf isNetworkd (
        lib.mkMerge [
          {
            networking.networkmanager.enable = lib.mkForce false;
            networking.wireless.enable = false;

            networking.useNetworkd = true;
            systemd.network.enable = true;
            systemd.network.wait-online.anyInterface = lib.mkDefault true;

            systemd.network.config.networkConfig = lib.mkIf cfg.vpnCompat {
              ManageForeignRoutes = lib.mkDefault false;
              ManageForeignRoutingPolicyRules = lib.mkDefault false;
            };

            # Hosts can define higher-priority custom units (e.g. systemd.network.networks."10-lan")
            # directly in den.aspects.<host>.nixos using upstream NixOS options.
            systemd.network.networks =
              (lib.optionalAttrs cfg.vpnCompat {
                "05-vpn-unmanaged" = {
                  matchConfig.Name = "wg* tun* tap*";
                  linkConfig.Unmanaged = true;
                };
              })
              // {
                "20-wired" = {
                  matchConfig.Name = lib.mkDefault "en* eth*";
                  networkConfig = {
                    DHCP = lib.mkDefault "yes";
                    IPv6AcceptRA = lib.mkDefault true;
                  }
                  // lib.optionalAttrs (netCfg.defaultDNS != [ ]) {
                    DNS = lib.mkDefault netCfg.defaultDNS;
                  };
                  dhcpV4Config = {
                    RouteMetric = lib.mkDefault 100;
                    UseDNS = lib.mkDefault (!effectiveIgnoreDHCPDNS);
                  };
                  dhcpV6Config.UseDNS = lib.mkDefault (!effectiveIgnoreDHCPDNS);
                  ipv6AcceptRAConfig = {
                    RouteMetric = lib.mkDefault 100;
                    UseDNS = lib.mkDefault (!effectiveIgnoreDHCPDNS);
                  };
                };

                "25-wireless" = {
                  matchConfig.Type = lib.mkDefault "wlan";
                  networkConfig = {
                    DHCP = lib.mkDefault "yes";
                    IPv6AcceptRA = lib.mkDefault true;
                  }
                  // lib.optionalAttrs (netCfg.defaultDNS != [ ]) {
                    DNS = lib.mkDefault netCfg.defaultDNS;
                  };
                  dhcpV4Config = {
                    RouteMetric = lib.mkDefault 600;
                    UseDNS = lib.mkDefault (!effectiveIgnoreDHCPDNS);
                  };
                  dhcpV6Config.UseDNS = lib.mkDefault (!effectiveIgnoreDHCPDNS);
                  ipv6AcceptRAConfig = {
                    RouteMetric = lib.mkDefault 600;
                    UseDNS = lib.mkDefault (!effectiveIgnoreDHCPDNS);
                  };
                };
              };
          }

          (lib.optionalAttrs (netLib.hasPreservation host) {
            preservation.preserveAt."/persist".directories = [
              "/var/lib/systemd/network"
            ];
          })
        ]
      );
  };
}
