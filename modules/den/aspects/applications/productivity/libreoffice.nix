{
  den.aspects.applications.productivity.libreoffice = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        libreoffice
        hunspell
        hunspellDicts.en_US
        hunspellDicts.pt_PT
        hyphenDicts.en_US
        hyphenDicts.pt_PT
      ];
    };

    persistHome.directories = [
      ".config/libreoffice"
    ];
  };
}
