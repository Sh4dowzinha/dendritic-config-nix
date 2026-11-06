{
  den.aspects.core.nix.nix-ld = {
    nixos =
      {
        lib,
        pkgs,
        nix-ld-libraries ? [ ],
        ...
      }:
      let
        # Handle aspects that pass `{ pkgs, ... }: [ ... ]` or direct package lists `[ ... ]`
        resolve = x: if lib.isFunction x then x { inherit pkgs; } else x;
        resolvedLibs = map resolve nix-ld-libraries;
      in
      {
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
      };
  };
}
