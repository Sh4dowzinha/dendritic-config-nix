{
  den.aspects.core.system.fhs-compat = {
    nixos =
      {
        pkgs,
        lib,
        nix-ld-libraries ? [ ],
        ...
      }:
      let
        # Handle aspects that pass `{ pkgs, ... }: [ ... ]` or direct package lists `[ ... ]`
        resolve = x: if lib.isFunction x then x { inherit pkgs; } else x;
        resolvedLibs = map resolve nix-ld-libraries;
      in
      {
        # 1. ELF dynamic linker interception
        programs.nix-ld = {
          enable = true;
          libraries = lib.unique (
            (with pkgs; [
              # Default base libraries
              zlib
              zstd
              stdenv.cc.cc
              curl
              openssl
              attr
              libssh
              bzip2
              libxml2
              acl
              libsodium
              util-linux
              xz
              systemd
            ])
            ++ (lib.flatten resolvedLibs)
          );
        };

        # 2. Script shebang entrypoint interception
        systemd.tmpfiles.rules = [
          "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
          "L+ /usr/bin/bash - - - - ${pkgs.bash}/bin/bash"
        ];
      };
  };
}
