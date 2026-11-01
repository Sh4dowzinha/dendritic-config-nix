{ den, lib, ... }:
let
  inherit (lib) mkOption types;
  settingsType = import ./_settings-type.nix { inherit den lib; };

  sshKeyType = types.submodule {
    options = {
      tag = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Tag to categorize the SSH key (e.g., 'laptop', 'workstation', 'nitrokey')";
      };
      key = mkOption {
        type = types.str;
        description = "SSH public key string";
      };
    };
  };
in
{
  den.schema.user.imports = [
    {
      options = {
        settings =
          mkOption {
            type = settingsType;
            default = { };
            description = "Per-aspect typed settings for the user";
          }
          // {
            identity = false;
          };

        identity = mkOption {
          type = types.submodule {
            options = {
              displayName = mkOption {
                type = types.str;
                default = "";
                description = "Display name for the user";
              };
              email = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Email address for the user";
              };
              gpgKey = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "GPG key ID for the user";
              };
              sshKeys = mkOption {
                type = types.listOf sshKeyType;
                default = [ ];
                description = "SSH public keys for the user, each with an optional tag";
              };
            };
          };
          default = { };
          description = "User identity information";
        };

        system = mkOption {
          type = types.submodule {
            options = {
              uid = mkOption {
                type = types.nullOr types.int;
                default = null;
              };
              gid = mkOption {
                type = types.nullOr types.int;
                default = null;
              };
              linger = mkOption {
                type = types.bool;
                default = false;
              };
            };
          };
          default = { };
        };
      };
    }
  ];
}
