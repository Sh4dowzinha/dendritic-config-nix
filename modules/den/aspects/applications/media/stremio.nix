{
  den.aspects.applications.media.stremio = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.stremio-linux-shell ];
    };

    persistHome.directories = [
      ".local/share/stremio"
    ];

    cacheHome.directories = [
      ".cache/stremio"
    ];
  };
}
