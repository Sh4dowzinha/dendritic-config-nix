# modules/den/aspects/core/network/iwd.nix
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
  den.aspects.core.network.iwd = {
    settings = {
      bandPreference = mkOption {
        type = types.enum [
          "prefer-5ghz"
          "prefer-6ghz"
          "balanced"
        ];
        default = "prefer-5ghz";
        description = "Frequency band ranking preset mapped to networking.wireless.iwd.settings.Rank.BandModifier* multipliers.";
      };
    };

    nixos =
      {
        host,
        config,
        lib,
        ...
      }:
      let
        netCfg = host.settings.core.network;
        iwdCfg = netCfg.iwd;
        isNetworkd = netCfg.backend == "networkd";
        isDeclarative = netCfg.mode == "declarative";
        isImperative = netCfg.mode == "imperative";

        bandModifiers =
          {
            balanced = {
              BandModifier2_4GHz = 1.0;
              BandModifier5GHz = 1.0;
              BandModifier6GHz = 1.0;
            };
            prefer-5ghz = {
              BandModifier2_4GHz = 0.5;
              BandModifier5GHz = 1.5;
              BandModifier6GHz = 1.5;
            };
            prefer-6ghz = {
              BandModifier2_4GHz = 0.4;
              BandModifier5GHz = 1.2;
              BandModifier6GHz = 2.0;
            };
          }
          .${iwdCfg.bandPreference};
      in
      lib.mkIf isNetworkd (
        lib.mkMerge [
          {
            networking.wireless.iwd = {
              enable = true;
              settings = {
                General = {
                  EnableNetworkConfiguration = lib.mkDefault false;
                  AddressRandomization = lib.mkDefault netCfg.macRandomization;
                  AddressRandomizationRange = lib.mkDefault netCfg.macRandomizationRange;
                  RoamThreshold = lib.mkDefault (-70);
                  RoamThreshold5G = lib.mkDefault (-72);
                  RoamRetryInterval = lib.mkDefault 60;
                };
                Network = {
                  EnableIPv6 = lib.mkDefault true;
                  NameResolvingService = lib.mkDefault "systemd";
                };
                Rank = lib.mapAttrs (_: lib.mkDefault) bandModifiers;
                Settings = {
                  AutoConnect = lib.mkDefault true;
                };
              };
            };
          }

          (lib.mkIf (isDeclarative && netCfg.wirelessNetworks != { }) {
            sops.secrets = netLib.mkWirelessSopsSecrets netCfg.wirelessNetworks;

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
                path = "/var/lib/iwd/${netLib.iwdFileName net.ssid ext}";
                owner = "root";
                group = "root";
                mode = "0600";
                content = ''
                  ${securitySection}
                  [Settings]
                  AutoConnect=${lib.boolToString net.autoConnect}
                  ${lib.optionalString net.hidden "Hidden=true"}
                  ${lib.optionalString (net.priority != null) "Priority=${toString net.priority}"}
                '';
              }
            ) netCfg.wirelessNetworks;

            systemd.services.iwd = {
              after = [ "sops-nix.service" ];
              restartTriggers = lib.mapAttrsToList (
                name: net:
                let
                  ext = if net.auth == "wpa-eap" then "8021x" else "psk";
                in
                config.sops.templates."iwd-${name}.${ext}".file
              ) netCfg.wirelessNetworks;
            };
          })

          (lib.optionalAttrs (isImperative && netLib.hasPreservation host) {
            preservation.preserveAt."/persist".directories = [
              {
                directory = "/var/lib/iwd";
                mode = "0700";
              }
            ];
          })
        ]
      );
  };
}
