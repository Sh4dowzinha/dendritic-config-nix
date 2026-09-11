{ den, ... }:
{
  den.aspects.roles.workstation = {
    includes = with den.aspects; [
      # Hardware
      hardware.audio
      hardware.bluetooth
      hardware.ddcutil

      # Theming
      desktop.style.stylix
      desktop.style.fonts

      # Virtualization
      #virtualization.libvirt

      # Desktop
      desktop.xserver
      desktop.xwayland
      desktop.xdg-portal

      # Apps
      applications.terminals.kitty
      applications.browsers.firefox

      applications.productivity.obs-studio
      applications.productivity.obsidian
      applications.productivity.zathura
    ];
  };
}
