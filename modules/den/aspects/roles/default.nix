{ den, ... }:
{
  den.aspects.roles.default = {
    includes = with den.aspects; [
      core.nix
      core.nix.nixpkgs
      core.systemd.boot
      core.localization.i18n
      core.nix.stateVersion
      core.systemd
      core.users.shell
      core.network.firewall
      core.network.dns
      core.utils
      core.system.firmware
      core.security
      core.system.facter
      core.users.home-manager-shared
      core.security.sudo
      core.localization.time
      core.perf.ssd
      core.perf.zram-swap
      core.system.linux-kernel
      core.users

      core.preservation

      applications.shell.zsh

      core.security.openssh
    ];
  };
}
