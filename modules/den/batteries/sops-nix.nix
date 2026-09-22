{
  den,
  inputs,
  rootPath,
  lib,
  ...
}:
let
  # Skip sops-nix integration for droid hosts
  sopsHostAspect =
    { host, ... }:
    let
      # Only real (NixOS) preservation relocates the host key under /persist; the
      # darwin preservation branch is a dummy (no wipe, no /persist), so a darwin
      # host must read its identity from the plain /etc/ssh path. Without this
      # guard the darwin host got `/persist/etc/ssh/...`, which doesn't exist, so
      # system sops-nix had no identity to decrypt the per-user secrets with.
      hasPreservation = host.hasAspect den.aspects.core.preservation;
      persistPrefix = lib.optionalString (hasPreservation && host.class == "nixos") "/persist";
      hostSopsFile = rootPath + "/secrets/hosts/${host.name}.yaml";
    in
    {
      name = "sops-nix/${host.name}";
      ${host.class} =
        if host.class == "droid" then
          { }
        else
          { config, lib, ... }:
          {
            imports = [
              inputs.sops-nix."${host.class}Modules".sops
            ];

            sops = {
              defaultSopsFile = hostSopsFile;
              defaultSopsFormat = "yaml";

              # The host's persisted SSH Ed25519 key is used
              # directly as the machine's age identity.
              age.sshKeyPaths = [
                "${persistPrefix}/etc/ssh/ssh_host_ed25519_key"
              ];

              # Per-user identity secrets are emitted by sopsUserAspect at user scope
            };

            # Make secrets paths available as module arg
            _module.args.secrets = lib.mapAttrs (_: v: v.path) config.sops.secrets;
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
      mergedSecrets = lib.mergeAttrsList (map (m: m.sops.secrets or { }) sops-secrets);
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
              _module.args.secrets = lib.mapAttrs (_: v: v.path) config.sops.secrets;
            }
          )
        ];

      homeManager = { config, ... }: {
        sops = {
          defaultSopsFormat = "yaml";
          gnupg.home = "${config.home.homeDirectory}/.gnupg";
          secrets = mergedSecrets;
        }
        // lib.optionalAttrs userSopsFileExists {
          defaultSopsFile = userSopsFile;
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

  # Useful SOPS tooling in the existing devshell.
  perSystem = { pkgs, ... }: {
    devshells.default.packages = [
      pkgs.sops
      pkgs.age
      pkgs.ssh-to-age
      pkgs.gnupg
    ];
  };
}
