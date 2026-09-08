{ den, ... }:
{
  den.aspects.roles.dev-gui = {
    includes = with den.aspects; [
      applications.dev.editor.codium.vscode
      applications.dev.editor.codium.core
      applications.dev.lang.c
      applications.dev.lang.go
      applications.dev.lang.lua
      applications.dev.lang.markdown
      applications.dev.lang.nix
      applications.dev.lang.python
      applications.dev.lang.shell
      applications.dev.networking.wireshark
    ];
  };
}
