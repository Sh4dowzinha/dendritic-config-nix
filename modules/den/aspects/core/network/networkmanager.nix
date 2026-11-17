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
  den.aspects.core.network.networkmanager = {
    settings = {
      wifiBackend = mkOption {
        type = types.enum [
          "wpa_supplicant"
          "iwd"
        ];
        default = "wpa_supplicant";
        description = "Wireless supplicant backend used by NetworkManager.";
      };

      ethernetMacRandomization = mkOption {
        type = types.enum [
          "preserve"
          "network"
          "once"
          "disabled"
        ];
        default = "preserve";
        description = "Ethernet MAC address policy (\"preserve\", \"network\" -> stable, \"once\" -> random, \"disabled\" -> permanent).";
      };
    };

    nixos =
      {
        host,
        config,
        lib,
        resolved-users ? [ ],
        ...
      }:
      let
        netCfg = host.settings.core.network;
        nmCfg = netCfg.networkmanager;
        isNM = netCfg.backend == "networkmanager";
        isIwd = nmCfg.wifiBackend == "iwd";
        isDeclarative = netCfg.mode == "declarative";
        isImperative = netCfg.mode == "imperative";
        userNames = map (u: u.userName or u.name) resolved-users;

        effectiveIgnoreDHCPDNS = netCfg.ignoreDHCPDNS || (netCfg.defaultDNS != [ ]);

        wifiMacMap = {
          network = "stable-ssid";
          once = "random";
          disabled = "permanent";
        };

        ethMacMap = {
          preserve = "preserve";
          network = "stable";
          once = "random";
          disabled = "permanent";
        };

        # Strip optional systemd-resolved '#sni' suffixes so shared DNS lists work across backends
        strippedDNS = map (s: lib.head (lib.splitString "#" s)) netCfg.defaultDNS;
      in
      lib.mkIf isNM (
        lib.mkMerge [
          {
            networking.networkmanager = {
              enable = true;
              wifi = {
                backend = nmCfg.wifiBackend;
                macAddress = lib.mkDefault wifiMacMap.${netCfg.macRandomization};
                scanRandMacAddress = lib.mkDefault (netCfg.macRandomization != "disabled");
              };
              ethernet.macAddress = lib.mkDefault ethMacMap.${nmCfg.ethernetMacRandomization};
              settings = {
                connection =
                  lib.optionalAttrs (netCfg.macRandomization != "disabled" && netCfg.macRandomizationRange == "nic") {
                    "wifi.generate-mac-address-mask" = lib.mkDefault "FF:FF:FF:00:00:00";
                  }
                  //
                    lib.optionalAttrs
                      (
                        nmCfg.ethernetMacRandomization != "preserve"
                        && nmCfg.ethernetMacRandomization != "disabled"
                        && netCfg.macRandomizationRange == "nic"
                      )
                      {
                        "ethernet.generate-mac-address-mask" = lib.mkDefault "FF:FF:FF:00:00:00";
                      }
                  // lib.optionalAttrs effectiveIgnoreDHCPDNS {
                    "ipv4.ignore-auto-dns" = lib.mkDefault true;
                    "ipv6.ignore-auto-dns" = lib.mkDefault true;
                  };
              }
              // lib.optionalAttrs (strippedDNS != [ ]) {
                "global-dns-domain-*" = {
                  servers = lib.mkDefault (lib.concatStringsSep "," strippedDNS);
                };
              };
            };

            networking.useNetworkd = false;
            networking.wireless.enable = false;

            users.users = lib.genAttrs userNames (_: {
              extraGroups = [ "networkmanager" ];
            });
          }

          (lib.mkIf (!isIwd) {
            networking.wireless.iwd.enable = false;
          })

          # Experimental iwd backend with NixOS D-Bus activation boot-race fix
          (lib.mkIf isIwd {
            networking.wireless.iwd = {
              enable = true;
              settings = {
                General.EnableNetworkConfiguration = lib.mkDefault false;
                Settings.AutoConnect = lib.mkDefault false;
              };
            };

            systemd.services.iwd = {
              wantedBy = lib.mkForce [ ];
              after = [ "systemd-udev-settle.service" ];
            };
          })

          (lib.mkIf (isDeclarative && netCfg.wirelessNetworks != { }) {
            sops.secrets = netLib.mkWirelessSopsSecrets netCfg.wirelessNetworks;

            sops.templates."nm-wireless-secrets.env" = {
              mode = "0400";
              content = lib.concatStringsSep "\n" (
                lib.concatLists (
                  lib.mapAttrsToList (
                    name: net:
                    let
                      tok = netLib.envToken name;
                    in
                    [ "WIFI_${tok}_PSK=${config.sops.placeholder."wifi-${name}-psk"}" ]
                    ++
                      lib.optional (net.auth == "wpa-eap" && net.eap.identitySopsKey != null)
                        "WIFI_${tok}_IDENTITY=${config.sops.placeholder."wifi-${name}-identity"}"
                  ) netCfg.wirelessNetworks
                )
              );
            };

            networking.networkmanager.ensureProfiles = {
              environmentFiles = [
                config.sops.templates."nm-wireless-secrets.env".path
              ];
              profiles = lib.mapAttrs (
                name: net:
                let
                  tok = netLib.envToken name;
                  baseProfile = {
                    connection = {
                      id = net.ssid;
                      type = "wifi";
                      autoconnect = net.autoConnect;
                    }
                    // lib.optionalAttrs (net.priority != null) {
                      autoconnect-priority = net.priority;
                    };
                    wifi = {
                      mode = "infrastructure";
                      ssid = net.ssid;
                      hidden = net.hidden;
                    };
                    ipv4 = {
                      method = "auto";
                    }
                    // lib.optionalAttrs effectiveIgnoreDHCPDNS {
                      ignore-auto-dns = true;
                    };
                    ipv6 = {
                      addr-gen-mode = "stable-privacy";
                      method = "auto";
                    }
                    // lib.optionalAttrs effectiveIgnoreDHCPDNS {
                      ignore-auto-dns = true;
                    };
                  };

                  pskSecurity = {
                    wifi-security = {
                      key-mgmt = "wpa-psk";
                      psk = "$WIFI_${tok}_PSK";
                    };
                  };

                  eapSecurity = {
                    wifi-security = {
                      key-mgmt = "wpa-eap";
                    };
                    "802-1x" = {
                      eap = net.eap.method;
                      phase2-auth = net.eap.phase2Auth;
                      identity = if net.eap.identitySopsKey != null then "$WIFI_${tok}_IDENTITY" else net.eap.identity;
                      password = "$WIFI_${tok}_PSK";
                    }
                    // lib.optionalAttrs (net.eap.anonymousIdentity != null) {
                      anonymous-identity = net.eap.anonymousIdentity;
                    }
                    // lib.optionalAttrs (net.eap.caCert != null) {
                      ca-cert = toString net.eap.caCert;
                    }
                    // lib.optionalAttrs (net.eap.domainSuffixMatch != null) {
                      domain-suffix-match = net.eap.domainSuffixMatch;
                    };
                  };
                in
                baseProfile // (if net.auth == "wpa-eap" then eapSecurity else pskSecurity)
              ) netCfg.wirelessNetworks;
            };
          })

          (lib.optionalAttrs (netLib.hasPreservation host) {
            preservation.preserveAt."/persist".directories = [
              "/var/lib/NetworkManager"
            ]
            ++ lib.optionals isImperative [
              {
                directory = "/etc/NetworkManager/system-connections";
                mode = "0700";
              }
            ];
          })
        ]
      );
  };
}
