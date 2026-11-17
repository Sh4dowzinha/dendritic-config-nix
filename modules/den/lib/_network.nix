# modules/den/lib/_network.nix
{ den, lib }:
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

      priority = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Optional connection priority when multiple known networks are available (higher wins).";
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

  # Sanitize network attribute key into an uppercase environment variable token
  envToken = name: lib.toUpper (lib.replaceStrings [ "-" "." ] [ "_" "_" ] name);

  # iwd uses raw SSID for [A-Za-z0-9_-]+ and '=' + lowercase hex otherwise
  iwdFileName =
    ssid: ext:
    if builtins.match "^[A-Za-z0-9_-]+$" ssid != null then
      "${ssid}.${ext}"
    else
      let
        chars = lib.stringToCharacters ssid;
        toHex = c: lib.fixedWidthString 2 "0" (lib.toLower (lib.toHexString (lib.strings.charToInt c)));
      in
      "=${lib.concatMapStrings toHex chars}.${ext}";

  # Build sops.secrets attrset for all declared wireless networks
  mkWirelessSopsSecrets =
    wirelessNetworks:
    (lib.mapAttrs' (
      name: net:
      lib.nameValuePair "wifi-${name}-psk" {
        key = net.sopsKey;
      }
    ) wirelessNetworks)
    // (lib.mapAttrs'
      (
        name: net:
        lib.nameValuePair "wifi-${name}-identity" {
          key = net.eap.identitySopsKey;
        }
      )
      (
        lib.filterAttrs (_: net: net.auth == "wpa-eap" && net.eap.identitySopsKey != null) wirelessNetworks
      )
    );

  # Check whether root preservation is active on the host
  hasPreservation =
    host:
    host.hasAspect den.aspects.core.preservation && (host.settings.core.preservation.enable or true);
in
{
  inherit
    wirelessNetworkType
    envToken
    iwdFileName
    mkWirelessSopsSecrets
    hasPreservation
    ;
}
