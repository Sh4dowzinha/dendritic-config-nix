{
  den,
  inputs,
  rootPath,
  lib,
  ...
}:
let
  # Normalizes both `{ sops.secrets.foo = ...; }` and shorthand `{ foo = ...; }`
  extractSecrets = list: map (m: m.sops.secrets or m) list;

  sopsHostAspect =
    {
      host,
      sops-secrets ? [ ],
      ...
    }:
    let
      hasPreservation =
        host.hasAspect den.aspects.core.preservation && (host.settings.core.preservation.enable or false);
      persistPrefix = lib.optionalString (hasPreservation && host.class == "nixos") "/persist";
      hostSopsFile = rootPath + "/secrets/hosts/${host.name}/${host.name}.yaml";
      hostSopsFileExists = builtins.pathExists hostSopsFile;
      secretList = extractSecrets sops-secrets;
    in
    {
      name = "sops-nix/${host.name}";
      ${host.class} =
        { config, lib, ... }:
        {
          imports = [
            inputs.sops-nix."${host.class}Modules".sops
          ];

          assertions = [
            {
              assertion = (config.sops.secrets != { }) -> hostSopsFileExists;
              message = "sops-nix: host '${host.name}' declares secrets, but ${toString hostSopsFile} does not exist (or is not git-tracked).";
            }
          ];

          sops = {
            defaultSopsFormat = "yaml";

            # The host's persisted SSH Ed25519 key is used directly as the machine's age identity.
            age.sshKeyPaths = [
              "${persistPrefix}/etc/ssh/ssh_host_ed25519_key"
            ];
          }
          // lib.optionalAttrs hostSopsFileExists {
            defaultSopsFile = hostSopsFile;
          }
          // lib.optionalAttrs (secretList != [ ]) {
            secrets = lib.mkMerge secretList;
          };

          # Make secret paths available as module arg
          _module.args.secretPaths = lib.mapAttrs (_: v: v.path) config.sops.secrets;
        };
    };

  sopsUserAspect =
    {
      user,
      host,
      sops-secrets ? [ ],
      ...
    }:
    let
      userSopsFile = rootPath + "/secrets/users/${user.userName}.yaml";
      userSopsFileExists = builtins.pathExists userSopsFile;
      secretList = extractSecrets sops-secrets;
    in
    {
      name = "sops-nix/${user.name}@${host.name}";

      homeManagerModules =
        { inputs', ... }:
        [
          inputs'.sops-nix.homeManagerModules.sops
          (
            { config, lib, ... }:
            {
              _module.args.secretPaths = lib.mapAttrs (_: v: v.path) config.sops.secrets;
            }
          )
        ];

      homeManager =
        { config, ... }:
        {
          assertions = [
            {
              assertion = (secretList != [ ]) -> userSopsFileExists;
              message = "sops-nix: user '${user.userName}' declares secrets, but ${toString userSopsFile} does not exist (or is not git-tracked).";
            }
          ];

          sops = {
            defaultSopsFormat = "yaml";
            age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          }
          // lib.optionalAttrs userSopsFileExists {
            defaultSopsFile = userSopsFile;
          }
          // lib.optionalAttrs (secretList != [ ]) {
            secrets = lib.mkMerge secretList;
          };
        };
    };
in
{
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  den.schema.host.includes = [ sopsHostAspect ];
  den.schema.user.includes = [ sopsUserAspect ];

  # SOPS tooling and key generators in the default devshell.
  perSystem =
    { pkgs, ... }:
    {
      devshells.default.packages = [
        pkgs.sops
        pkgs.age
        pkgs.ssh-to-age
        pkgs.gnupg
      ];
    };
}
