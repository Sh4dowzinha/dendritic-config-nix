{
  den.aspects.roles.creative.daw = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        makePluginPath =
          format:
          lib.concatStringsSep ":" (
            lib.unique [
              "${config.home.homeDirectory}/.${format}"
              "${config.home.profileDirectory}/lib/${format}"
              "${config.home.homeDirectory}/.nix-profile/lib/${format}"
              "/run/current-system/sw/lib/${format}"
            ]
          );
      in
      {
        home.packages = with pkgs; [
          # Per-process PipeWire JACK shim (`pw-jack <app>`)
          pipewire.jack

          # DAWs & audio synthesis environments
          reaper
          ardour
          audacity
          sunvox
          supercollider

          # PipeWire patchbay/debug & Windows VST bridge
          coppwr
          yabridge
          yabridgectl

          # Synths, samplers & plugins
          vital
          odin2
          fire
          decent-sampler
          lsp-plugins
        ];

        home.sessionVariables = {
          CLAP_PATH = makePluginPath "clap";
          DSSI_PATH = makePluginPath "dssi";
          LADSPA_PATH = makePluginPath "ladspa";
          LV2_PATH = makePluginPath "lv2";
          LXVST_PATH = makePluginPath "lxvst";
          VST_PATH = makePluginPath "vst";
          VST3_PATH = makePluginPath "vst3";
        };
      };
  };
}
