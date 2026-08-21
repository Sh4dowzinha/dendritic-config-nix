{
  den.aspects.ssh = {
    provides.client-config = {
      preservation-user-class = {
        directories = [
          { directory = ".ssh"; mode = "0700"; }
        ];
      };
      
      homeManager = {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
        };
      };
    };
  };
}
