{ den, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.aspects.hardware.gpu.nvidia = {
    includes = [ den.aspects.hardware.gpu.common ];

    settings = {
      branch = mkOption {
        type = types.enum [
          "stable"
          "latest"
          "production"
          "beta"
          "legacy_580"
        ];
        default = "latest";
        description = "NVIDIA driver branch from boot.kernelPackages.nvidiaPackages.";
      };

      open = mkOption {
        type = types.bool;
        default = true;
        description = "Use the NVIDIA open kernel module (Turing / RTX 20-series and newer; set false for Maxwell/Pascal).";
      };

      dynamicBoost = mkOption {
        type = types.bool;
        default = false;
        description = "Enable NVIDIA Dynamic Boost daemon on supported laptops.";
      };

      prime = {
        mode = mkOption {
          type = types.enum [
            "none"
            "offload"
            "primary"
          ];
          default = "none";
          description = "Optimus mode: \"none\" (dGPU only), \"offload\" (iGPU primary + nvidia-offload), or \"primary\" (dGPU primary on Wayland & X11 sync).";
        };

        finegrained = mkOption {
          type = types.bool;
          default = false;
          description = "Enable RTD3 fine-grained GPU power management (requires Turing+ and prime.mode = \"offload\").";
        };

        nvidiaBusId = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional manual override for NVIDIA PCI bus ID (decimal PCI:bus@domain:dev:func); auto-detected from facter when null.";
        };

        intelBusId = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional manual override for Intel iGPU PCI bus ID; auto-detected from facter when null.";
        };

        amdgpuBusId = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional manual override for AMD iGPU PCI bus ID; auto-detected from facter when null.";
        };
      };
    };

    nixos =
      {
        config,
        host,
        pkgs,
        ...
      }:
      let
        cfg = host.settings.hardware.gpu.nvidia;
        isOffload = cfg.prime.mode == "offload";
        isPrimary = cfg.prime.mode == "primary";
        isPrime = isOffload || isPrimary;
        isAmdOffload = isOffload && host.hasAspect den.aspects.hardware.gpu.amd;

        graphicsCards = lib.attrByPath [ "hardware" "graphics_card" ] [ ] (
          config.hardware.facter.report or { }
        );

        findCard =
          vendor: lib.lists.findFirst (card: (card.vendor.name or "") == vendor) null graphicsCards;

        nvidiaCard = findCard "nVidia Corporation";
        amdCard = findCard "ATI Technologies Inc";
        intelCard = findCard "Intel Corporation";
        igpuCard = if intelCard != null then intelCard else amdCard;
        hasHybridCards = igpuCard != null && nvidiaCard != null;

        # Convert Linux hex sysfs_bus_id ("0000:0e:00.0") to NixOS decimal ("PCI:14@0:0:0")
        formatPciId =
          id:
          let
            m = builtins.match "([0-9a-fA-F]+):([0-9a-fA-F]+):([0-9a-fA-F]+)\\.([0-9a-fA-F]+)" id;
            hex = s: toString (lib.fromHexString s);
          in
          assert m != null;
          "PCI:${hex (builtins.elemAt m 1)}@${hex (builtins.elemAt m 0)}:${hex (builtins.elemAt m 2)}:${hex (builtins.elemAt m 3)}";

        resolveBusId =
          override: card:
          if override != null then
            override
          else if card != null then
            formatPciId card.sysfs_bus_id
          else
            "";

        nvidiaBusId = resolveBusId cfg.prime.nvidiaBusId nvidiaCard;
        intelBusId = resolveBusId cfg.prime.intelBusId intelCard;
        amdgpuBusId = resolveBusId cfg.prime.amdgpuBusId amdCard;

        drmOrder = if isPrimary then "/dev/dri/dgpu1:/dev/dri/igpu1" else "/dev/dri/igpu1:/dev/dri/dgpu1";

        modprobeOpts = [
          "NVreg_UsePageAttributeTable=1"
        ]
        ++ lib.optional (!cfg.open) "NVreg_EnableGpuFirmware=0";
      in
      {
        assertions = [
          {
            assertion = cfg.prime.finegrained -> isOffload;
            message = "hardware.gpu.nvidia: prime.finegrained requires prime.mode = \"offload\".";
          }
          {
            assertion = isPrime -> (nvidiaBusId != "" && (intelBusId != "" || amdgpuBusId != ""));
            message = "hardware.gpu.nvidia: prime.mode = \"${cfg.prime.mode}\" requires detectable (or overridden) NVIDIA and iGPU PCI bus IDs.";
          }
        ];

        boot.extraModprobeConfig = "options nvidia ${lib.concatStringsSep " " modprobeOpts}";

        # Priority 75 overrides normal-priority (100) mkBefore "modesetting" from
        # gpu.intel / gpu.amd while keeping lib.mkForce (50) free for host overrides:
        # - primary (X11 PRIME sync): NixOS expects "nvidia" alone and generates the iGPU section.
        # - AMD + offload: NixOS hardcodes "amdgpu" in xorg.conf when amdgpuBusId is set.
        # - Intel + offload / standalone NVIDIA: appends "nvidia" after "modesetting" (or alone).
        services.xserver.videoDrivers =
          if isPrimary then
            lib.mkOverride 75 [ "nvidia" ]
          else if isAmdOffload then
            lib.mkOverride 75 [
              "amdgpu"
              "nvidia"
            ]
          else
            lib.mkAfter [ "nvidia" ];

        hardware.graphics.extraPackages = [
          pkgs.nvidia-vaapi-driver
        ];

        hardware.nvidia = {
          modesetting.enable = true;
          open = cfg.open;
          nvidiaSettings = false;
          package = config.boot.kernelPackages.nvidiaPackages.${cfg.branch};

          powerManagement = {
            enable = true;
            finegrained = cfg.prime.finegrained;
          };

          dynamicBoost.enable = cfg.dynamicBoost;

          prime = lib.mkIf isPrime {
            offload = lib.mkIf isOffload {
              enable = true;
              enableOffloadCmd = true;
            };
            sync.enable = isPrimary;
            inherit nvidiaBusId intelBusId amdgpuBusId;
          };
        };

        # Stable /dev/dri/{igpu1,dgpu1} symlinks + GNOME Mutter primary GPU tag
        services.udev.packages = lib.optionals hasHybridCards [
          (pkgs.writeTextDir "lib/udev/rules.d/99-drm-devices.rules" ''
            SUBSYSTEM=="drm", KERNEL=="card*", SUBSYSTEMS=="pci", KERNELS=="${igpuCard.sysfs_bus_id}", SYMLINK+="dri/igpu1"${lib.optionalString isOffload '', TAG+="mutter-device-preferred-primary"''}
            SUBSYSTEM=="drm", KERNEL=="card*", SUBSYSTEMS=="pci", KERNELS=="${nvidiaCard.sysfs_bus_id}", SYMLINK+="dri/dgpu1"${lib.optionalString isPrimary '', TAG+="mutter-device-preferred-primary"''}
          '')
        ];

        # Compositor-agnostic Wayland primary GPU ordering & client defaults
        environment.sessionVariables =
          lib.optionalAttrs (!isPrime) {
            LIBVA_DRIVER_NAME = lib.mkDefault "nvidia";
          }
          // lib.optionalAttrs (isPrime && hasHybridCards) {
            KWIN_DRM_DEVICES = drmOrder;
            AQ_DRM_DEVICES = drmOrder;
            WLR_DRM_DEVICES = drmOrder;
          }
          // lib.optionalAttrs isPrimary {
            "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
            "__NV_PRIME_RENDER_OFFLOAD" = "1";
            "__VK_LAYER_NV_optimus" = "NVIDIA_only";
          };
      };

    cacheHome.directories = [
      ".cache/nvidia"
    ];
  };
}
