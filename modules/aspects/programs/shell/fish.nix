{
  den.aspects.fish = {
    nixos = {
      programs.fish.enable = true;
    };
    
    darwin = {
      programs.fish.enable = true;
    };
  
    homeManager = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
        '';
      };
    };
  
    preservation-user-class = {
      files = [
        ".local/share/fish/fish_history"
      ];
    };      
  };
}
