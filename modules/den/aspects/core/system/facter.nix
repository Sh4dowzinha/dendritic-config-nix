{ inputs, ... }:
{
  den.aspects.core.system.facter = {
    nixos =
      { host, ... }:
      {
        hardware.facter = {
          reportPath = host.facts or null;
          detected = {
            dhcp.enable = false;
            graphics.enable = false;
          };
        };
      };
  };
}
