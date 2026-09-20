{
  den.aspects.applications.shell.fastfetch = {
    homeManager = {
      programs.fastfetch = {
        enable = true;
        settings = {
          modules = [
            "title"
            "separator"
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "display"
            "lm"
            "de"
            "wm"
            "wmtheme"
            "theme"
            "icons"
            "font"
            "cursor"
            "terminal"
            "terminalfont"
            "cpu"
            "gpu"
            "memory"
            "swap"
            "disk"
            "btrfs"
            "battery"
            "poweradapter"
            "localip"
            "locale"
            "break"
            "colors"
          ];
        };
      };
    };
  };
}
