{
  den.aspects.applications.dev.lang.lua = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.luaformatter
          pkgs.luajit
          pkgs.lua-language-server
          pkgs.stylua
        ];
      };

    codium-settings = [
      {
        "[lua]"."editor.defaultFormatter" = "JohnnyMorganz.stylua";
      }
    ];

    codium-extensions =
      { pkgs, ... }:
      [
        pkgs.vscode-marketplace.johnnymorganz.stylua
        pkgs.vscode-marketplace.yinfei.luahelper
      ];
  };
}
