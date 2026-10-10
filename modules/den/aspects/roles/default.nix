{ den, ... }:
{
  den.aspects.roles.default = {
    includes = with den.aspects; [
      core.nix
      core.nix.nixpkgs
      core.systemd.boot
      core.localization.i18n
      core.systemd
      core.users.shell
      core.network.firewall
      core.network.dns
      core.network.wireguard
      core.utils
      core.documentation
      core.system.firmware
      core.security
      core.system.facter
      core.users.home-manager-shared
      core.users.deterministic-uids
      core.security.sudo
      core.localization.time
      core.system.zram-swap
      core.system.appimage
      core.system.plymouth
      core.system.linux-kernel
      core.users

      core.preservation

      applications.shell.fish
      applications.shell.fastfetch

      core.security.openssh
    ];
  };
}
