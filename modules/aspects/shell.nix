{
  den.aspects.shell = {
    provides.fish = {
      nixos = {
        programs.fish.enable = true;
      };
    
      homeManager = {
        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting
          '';
          functions = {
            __fish_command_not_found_handler = {
              body = "__fish_default_command_not_found_handler $argv[1]";
              onEvent = "fish_command_not_found";
            };
          
            gitignore = "curl -sL https://www.gitignore.io/api/$argv";
          };
        };
      };
    
      preservation-user-class = {
        files = [
          ".local/share/fish/fish_history"
        ];
      };      
    };
  };
}
