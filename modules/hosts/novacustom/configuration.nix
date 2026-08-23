{ den, ... }: {
  den.aspects.novacustom = {
    includes = with den.aspects; [
      # System
      base-system
      preservation

      # Hardware
      intel
      intel.laptop-adl
      bluetooth
      nitrokey3

      # DE/WM
      gnome
      #kde
      #hyprland
      #noctalia
    ];
    
    nixos = { pkgs, ... }: {
      
      time.timeZone = "Europe/Lisbon";

      console.useXkbConfig = true;
      services.xserver.xkb.layout = "pt";
      
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocales = [ "pt_PT.UTF-8/UTF-8" ];

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "pt_PT.UTF-8";
        LC_IDENTIFICATION = "pt_PT.UTF-8";
        LC_MEASUREMENT = "pt_PT.UTF-8";
        LC_MONETARY = "pt_PT.UTF-8";
        LC_NAME = "pt_PT.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "pt_PT.UTF-8";
        LC_TELEPHONE = "pt_PT.UTF-8";
        LC_TIME = "pt_PT.UTF-8";
      };

      boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
      
      environment.systemPackages = with pkgs; [
        vim
        btop
        htop
        fastfetch
      ];
      
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        font-awesome
        nerd-fonts.jetbrains-mono
      ];
    };

    provides.to-users = {
      includes = with den.aspects; [ 
        preservation.provides.for-users
        gnome
      ];
      
      homeManager = { pkgs, ... }: {
        home.packages = with pkgs; [ 
          brave
          keepassxc
        ];
      };
      # TODO: move this to a dedicated brave aspect
      preservation-user-class = {
        directories = [
          ".config/BraveSoftware/Brave-Browser"
        ];
      };
    };
  };
}
