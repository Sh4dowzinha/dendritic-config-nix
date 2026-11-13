{ den, lib, ... }:
let
  inherit (lib) mkOption types;

  eapConfigType = types.submodule {
    options = {
      method = mkOption {
        type = types.enum [
          "peap"
          "ttls"
        ];
        default = "peap";
        description = "Outer EAP authentication method.";
      };

      phase2Auth = mkOption {
        type = types.enum [
          "mschapv2"
          "pap"
        ];
        default = "mschapv2";
        description = "Inner Phase 2 authentication protocol.";
      };

      identity = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Inner EAP identity (e.g. user@university.edu). Leave null if using identitySopsKey.";
      };

      identitySopsKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional SOPS key path for the inner EAP identity.";
      };

      anonymousIdentity = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Outer anonymous identity (e.g. anonymous@university.edu).";
      };

      caCert = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Optional path to the institutional CA certificate.";
      };

      domainSuffixMatch = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "RADIUS server domain suffix constraint.";
      };
    };
  };

  wirelessNetworkType = types.submodule {
    options = {
      ssid = mkOption {
        type = types.str;
        description = "Wireless network SSID.";
      };

      auth = mkOption {
        type = types.enum [
          "wpa-psk"
          "wpa-eap"
        ];
        default = "wpa-psk";
        description = "Authentication type: wpa-psk (personal) or wpa-eap (802.1x enterprise).";
      };

      sopsKey = mkOption {
        type = types.str;
        description = "Key path in the host SOPS file containing the WPA-PSK passphrase or 802.1x password.";
      };

      autoConnect = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to autoconnect to this SSID when in range.";
      };

      hidden = mkOption {
        type = types.bool;
        default = false;
        description = "Whether the SSID is hidden.";
      };

      eap = mkOption {
        type = eapConfigType;
        default = { };
        description = "802.1x Enterprise EAP configuration (used when auth = \"wpa-eap\").";
      };
    };
  };
in
{
  den.aspects.core.network = {
    includes = [
      den.aspects.core.network.dns
    ];

    settings = {
      backend = mkOption {
        type = types.enum [
          "networkmanager"
          "networkd"
        ];
        default = "networkmanager";
        description = "Network stack backend for the host.";
      };

      mode = mkOption {
        type = types.enum [
          "imperative"
          "declarative"
        ];
        default = "imperative";
        description = "Whether network connections are managed imperatively or declaratively";
      };

      wirelessNetworks = mkOption {
        type = types.attrsOf wirelessNetworkType;
        default = { };
        description = "Declarative wireless networks provisioned via sops-nix when mode = \"declarative\".";
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
        cfg = host.settings.core.network;
        isNM = cfg.backend == "networkmanager";
        isNetworkd = cfg.backend == "networkd";
        isDeclarative = cfg.mode == "declarative";
        isImperative = cfg.mode == "imperative";

        userNames = map (u: u.userName or u.name) resolved-users;

        envToken = name: lib.toUpper (lib.replaceStrings [ "-" "." ] [ "_" "_" ] name);

        iwdFileName =
          ssid: ext:
          if builtins.match "^[A-Za-z0-9_-]+$" ssid != null then
            "${ssid}.${ext}"
          else
            let
              chars = lib.stringToCharacters ssid;
              toHex = c: lib.fixedWidthString 2 "0" (lib.toHexString (lib.strings.charToInt c));
            in
            "=${lib.concatMapStrings toHex chars}.${ext}";

        wirelessSopsSecrets =
          (lib.mapAttrs' (
            name: net:
            lib.nameValuePair "wifi-${name}-psk" {
              key = net.sopsKey;
            }
          ) cfg.wirelessNetworks)
          // (lib.mapAttrs'
            (
              name: net:
              lib.nameValuePair "wifi-${name}-identity" {
                key = net.eap.identitySopsKey;
              }
            )
            (
              lib.filterAttrs (
                _: net: net.auth == "wpa-eap" && net.eap.identitySopsKey != null
              ) cfg.wirelessNetworks
            )
          );
      in
      lib.mkMerge [
        # Base Hostname & Assertions
        {
          networking.hostName = host.name;
          networking.useDHCP = false;

          assertions = lib.mapAttrsToList (name: net: {
            assertion =
              (net.auth == "wpa-eap") -> (net.eap.identity != null || net.eap.identitySopsKey != null);
            message = "core.network: wirelessNetworks.${name} uses auth = \"wpa-eap\", so either eap.identity or eap.identitySopsKey must be set.";
          }) cfg.wirelessNetworks;
        }

        # Backend: NetworkManager
        (lib.mkIf isNM {
          networking.networkmanager.enable = true;
          networking.useNetworkd = false;
          networking.wireless.enable = false;
          networking.wireless.iwd.enable = false;

          users.users = lib.genAttrs userNames (_: {
            extraGroups = [ "networkmanager" ];
          });
        })

        # Backend: NetworkManager + Declarative Mode
        (lib.mkIf (isNM && isDeclarative && cfg.wirelessNetworks != { }) {
          sops.secrets = wirelessSopsSecrets;

          sops.templates."nm-wireless-secrets.env" = {
            mode = "0400";
            content = lib.concatStringsSep "\n" (
              lib.concatLists (
                lib.mapAttrsToList (
                  name: net:
                  let
                    tok = envToken name;
                  in
                  [ "WIFI_${tok}_PSK=${config.sops.placeholder."wifi-${name}-psk"}" ]
                  ++
                    lib.optional (net.auth == "wpa-eap" && net.eap.identitySopsKey != null)
                      "WIFI_${tok}_IDENTITY=${config.sops.placeholder."wifi-${name}-identity"}"
                ) cfg.wirelessNetworks
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
                tok = envToken name;
                baseProfile = {
                  connection = {
                    id = net.ssid;
                    type = "wifi";
                    autoconnect = net.autoConnect;
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = net.ssid;
                    hidden = net.hidden;
                  };
                  ipv4.method = "auto";
                  ipv6 = {
                    addr-gen-mode = "stable-privacy";
                    method = "auto";
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
            ) cfg.wirelessNetworks;
          };
        })

        # Backend: systemd-networkd + iwd (DNS handled by core.network.dns)
        (lib.mkIf isNetworkd {
          networking.networkmanager.enable = lib.mkForce false;
          networking.wireless.enable = false;

          networking.useNetworkd = true;
          systemd.network.enable = true;
          systemd.network.wait-online.anyInterface = true;

          networking.wireless.iwd = {
            enable = true;
            settings = {
              General.EnableNetworkConfiguration = false;
              Network = {
                EnableIPv6 = true;
                NameResolvingService = "systemd";
              };
              Settings.AutoConnect = true;
            };
          };

          systemd.network.networks = {
            "20-wired" = {
              matchConfig.Name = lib.mkDefault "en* eth*";
              networkConfig = {
                DHCP = lib.mkDefault "yes";
                IPv6AcceptRA = lib.mkDefault true;
              };
              dhcpV4Config.RouteMetric = lib.mkDefault 100;
              ipv6AcceptRAConfig.RouteMetric = lib.mkDefault 100;
            };

            "25-wireless" = {
              matchConfig.Name = lib.mkDefault "wl*";
              networkConfig = {
                DHCP = lib.mkDefault "yes";
                IPv6AcceptRA = lib.mkDefault true;
              };
              dhcpV4Config.RouteMetric = lib.mkDefault 600;
              ipv6AcceptRAConfig.RouteMetric = lib.mkDefault 600;
            };
          };
        })

        # Backend: systemd-networkd + iwd + Declarative Mode
        (lib.mkIf (isNetworkd && isDeclarative && cfg.wirelessNetworks != { }) {
          sops.secrets = wirelessSopsSecrets;

          sops.templates = lib.mapAttrs' (
            name: net:
            let
              isEap = net.auth == "wpa-eap";
              ext = if isEap then "8021x" else "psk";

              resolvedIdentity =
                if net.eap.identitySopsKey != null then
                  config.sops.placeholder."wifi-${name}-identity"
                else
                  net.eap.identity;

              outerIdentity =
                if net.eap.anonymousIdentity != null then net.eap.anonymousIdentity else resolvedIdentity;

              eapPrefix = if net.eap.method == "peap" then "EAP-PEAP" else "EAP-TTLS";

              iwdPhase2Method =
                if net.eap.method == "peap" then
                  lib.toUpper net.eap.phase2Auth
                else
                  "Tunneled-TLS-${lib.toUpper net.eap.phase2Auth}";

              securitySection =
                if !isEap then
                  ''
                    [Security]
                    Passphrase=${config.sops.placeholder."wifi-${name}-psk"}
                  ''
                else
                  ''
                    [Security]
                    EAP-Method=${lib.toUpper net.eap.method}
                    EAP-Identity=${outerIdentity}
                    ${eapPrefix}-Phase2-Method=${iwdPhase2Method}
                    ${eapPrefix}-Phase2-Identity=${resolvedIdentity}
                    ${eapPrefix}-Phase2-Password=${config.sops.placeholder."wifi-${name}-psk"}
                  ''
                  + lib.optionalString (net.eap.caCert != null) ''
                    ${eapPrefix}-CACert=${toString net.eap.caCert}
                  ''
                  + lib.optionalString (net.eap.domainSuffixMatch != null) ''
                    ${eapPrefix}-ServerDomainMask=${net.eap.domainSuffixMatch}
                  '';
            in
            lib.nameValuePair "iwd-${name}.${ext}" {
              path = "/var/lib/iwd/${iwdFileName net.ssid ext}";
              owner = "root";
              group = "root";
              mode = "0600";
              content = ''
                ${securitySection}
                [Settings]
                AutoConnect=${lib.boolToString net.autoConnect}
                ${lib.optionalString net.hidden "Hidden=true"}
              '';
            }
          ) cfg.wirelessNetworks;

          systemd.services.iwd = {
            after = [ "sops-nix.service" ];
            restartTriggers = lib.mapAttrsToList (
              name: net:
              let
                ext = if net.auth == "wpa-eap" then "8021x" else "psk";
              in
              config.sops.templates."iwd-${name}.${ext}".file
            ) cfg.wirelessNetworks;
          };
        })

        # Conditional State Persistence (Root-on-Tmpfs)
        (lib.optionalAttrs (host.settings.core.preservation.enable or false) {
          preservation.preserveAt."/persist".directories =
            lib.optionals isNM [
              "/var/lib/NetworkManager"
            ]
            ++ lib.optionals (isNM && isImperative) [
              {
                directory = "/etc/NetworkManager/system-connections";
                mode = "0700";
              }
            ]
            ++ lib.optionals isNetworkd [
              "/var/lib/systemd/network"
            ]
            ++ lib.optionals (isNetworkd && isImperative) [
              {
                directory = "/var/lib/iwd";
                mode = "0700";
              }
            ];
        })
      ];
  };
}
