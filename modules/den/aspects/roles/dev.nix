{ den, ... }:
{
  den.aspects.roles.dev = {
    includes = with den.aspects; [
      hardware.adb

      applications.shell.nix-index

      applications.dev.editor.nvf

      applications.dev.security.gpg
      applications.dev.security.ssh

      applications.dev.shell.bat
      applications.dev.shell.bottom
      applications.dev.shell.btop
      applications.dev.shell.direnv
      applications.dev.shell.eza
      applications.dev.shell.starship

      applications.shell.yazi
      applications.shell.archive
      applications.shell.data
      applications.shell.disk
      applications.shell.process
      applications.shell.search
      applications.shell.zoxide

      applications.dev.git
      applications.dev.git.delta
      applications.dev.git.github
      applications.dev.git.jujutsu
      applications.dev.git.lazygit
      applications.dev.git.mergiraf

      applications.dev.lang.go
      applications.dev.lang.python
      applications.dev.lang.nix
    ];
  };
}
