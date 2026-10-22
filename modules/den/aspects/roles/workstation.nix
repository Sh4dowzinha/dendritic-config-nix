{ den, ... }:
{
  den.aspects.roles.workstation = {
    includes = with den.aspects; [
      # Hardware
      hardware.audio
      hardware.bluetooth
      hardware.ddcutil
      hardware.printers

      # Theming
      #desktop.style.stylix
      desktop.style.fonts

      # Virtualization
      #virtualization.libvirt

      # Desktop
      desktop.wine
      desktop.xserver
      desktop.xwayland
      desktop.xdg

      # Apps
      applications.productivity.obsidian
      applications.productivity.libreoffice
      applications.security.keepassxc
      applications.terminals.kitty
    ];
  };
}
