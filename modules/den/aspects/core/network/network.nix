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
  den.aspects.core.network = {
    includes = with den.aspects.core.network; [
      dns
      firewall
      networkmanager
      networkd
      iwd
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
        description = "Whether network connections are managed imperatively at runtime or declaratively via NixOS and sops-nix.";
      };

      defaultDNS = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Host-wide custom DNS servers applied across links regardless of active backend (automatically ignores DHCP/RA DNS).";
      };

      ignoreDHCPDNS = mkOption {
        type = types.bool;
        default = false;
        description = "Ignore router/ISP DNS servers pushed via DHCPv4, DHCPv6, and IPv6 RA across all links.";
      };

      macRandomization = mkOption {
        type = types.enum [
          "network"
          "once"
          "disabled"
        ];
        default = "network";
        description = "Wi-Fi MAC address randomization policy (\"network\" -> per-SSID stable, \"once\" -> random per scan/boot, \"disabled\" -> permanent).";
      };

      macRandomizationRange = mkOption {
        type = types.enum [
          "full"
          "nic"
        ];
        default = "full";
        description = "Randomize all 6 MAC octets (\"full\") or preserve the 3-byte vendor OUI (\"nic\").";
      };

      wirelessNetworks = mkOption {
        type = types.attrsOf netLib.wirelessNetworkType;
        default = { };
        description = "Declarative wireless networks provisioned via sops-nix when mode = \"declarative\".";
      };
    };

    nixos =
      { host, lib, ... }:
      let
        cfg = host.settings.core.network;
      in
      {
        networking.hostName = host.name;
        networking.useDHCP = false;

        assertions = lib.mapAttrsToList (name: net: {
          assertion =
            (net.auth == "wpa-eap") -> (net.eap.identity != null || net.eap.identitySopsKey != null);
          message = "core.network: wirelessNetworks.${name} uses auth = \"wpa-eap\", so either eap.identity or eap.identitySopsKey must be set.";
        }) cfg.wirelessNetworks;
      };
  };
}
