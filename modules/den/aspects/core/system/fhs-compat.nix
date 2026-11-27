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
              zlib
              zstd
              stdenv.cc.cc.lib
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

        # 2. Static bash shebangs without touching NixOS's native /bin/sh or /usr/bin/env
        systemd.tmpfiles.rules = [
          "L+ /bin/bash - - - - ${lib.getExe pkgs.bash}"
          "L+ /usr/bin/bash - - - - ${lib.getExe pkgs.bash}"
        ];
      };
  };
}
