{
  den,
  lib,
  inputs,
  ...
}:
{
  den.aspects.core.preservation = {
    includes = [
      den.aspects.core.preservation.persist-collector
      den.aspects.core.preservation.persist-home-collector
      den.aspects.core.preservation.tmpfs
    ];

    nixos = { user, ... }: {
      imports = [
        inputs.preservation.nixosModules.preservation
      ];

      preservation = {
        preserveAt = {
          "/cache" = {
            persistentStoragePath = "/cache";
            commonMountOptions = [
              "x-gvfs-hide"
              "x-gdu.hide"
            ];
            
            directories = [
              "/var/lib/nixos"
              "/var/tmp"
              "/srv"
            ];
              
            users.${user.userName} = {
              commonMountOptions = [
                "x-gvfs-hide"
                "x-gdu.hide"
              ];
                
              directories = [
                "Downloads"
                ".local/share/direnv"
                ".local/state/nix"
                ".cache"
              ];
            };
          };

          "/persist" = {
            commonMountOptions = [
              "x-gvfs-hide"
              "x-gdu.hide"
            ];
              
            directories = [ ];
              
            files = [
              "/etc/machine-id"
              "/etc/adjtime"
              # Host key for systemd LoadCredentialEncrypted. Must persist so
              # blobs encrypted against it (e.g. libvirt's secrets-encryption-key
              # under the persisted /var/lib/libvirt) stay decryptable across boots.
              "/var/lib/systemd/credential.secret"
            ];
              
            users.${user.userName} = {
              commonMountOptions = [
                "x-gvfs-hide"
                "x-gdu.hide"
              ];
                
              directories = [
                "Desktop"
                "Documents"
                "Music"
                "Pictures"
                "Projects"
                "Public"
                "Templates"
                "Videos"
                {
                directory = ".ssh";
                mode = "0700";
                }
                {
                directory = ".local/share/keyrings";
                mode = "0700";
                }
              ];
            };    
          };
        };
      };
    };
  };
}
