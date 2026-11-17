# User registry and host -> user resolution.
{
  lib,
  den,
  config,
  ...
}:
let
  inherit (den.lib.policy) resolve;
  inherit (lib) mkOption types;

  registryUserType = types.submodule (
    { name, config, ... }:
    {
      imports = [ den.schema.user ];

      config._module.args.user = config;

      options = {
        name = mkOption {
          type = types.str;
          default = name;
        };

        userName = mkOption {
          type = types.str;
          default = name;
        };

        classes = mkOption {
          type = types.listOf types.str;
          default = [ "homeManager" ];
        };

        aspect = mkOption {
          type = types.raw;
          default = den.aspects.${name} or { };
        };

        groups = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    }
  );
in
{
  options.den.users.registry = mkOption {
    type = types.attrsOf registryUserType;
    default = { };
  };

  config = {
    den.schema.user.isEntity = true;
    den.schema.user.classes = lib.mkDefault [ "homeManager" ];

    den.policies.host-users =
      { host, ... }:
      let
        ownerList = lib.optional (host.system-owner != null) host.system-owner;
        rawUsers = host.users or { };
        extraUsers = if builtins.isList rawUsers then rawUsers else builtins.attrNames rawUsers;
        targetUsers = lib.unique (ownerList ++ extraUsers);
      in
      lib.concatMap (
        uName:
        lib.optional (config.den.users.registry ? ${uName}) (
          resolve.to "user" {
            user = config.den.users.registry.${uName};
          }
        )
      ) targetUsers;

    den.schema.host.includes = [
      den.policies.host-users
    ];
  };
}
