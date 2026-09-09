{ den, ... }:
{
  den.aspects.roles.workstation = {
    includes = with den.aspects; [
      # Hardware
      hardware.audio
      hardware.bluetooth
      hardware.coolercontrol
      hardware.ddcutil
      hardware.keyboard

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
      applications.terminals.alacritty
      applications.terminals.kitty
      applications.browsers.firefox
      applications.browsers.chromium

      applications.mail.protonmail

      applications.productivity.obs-studio
      applications.productivity.obsidian
      applications.productivity.zathura
    ];
  };
}
