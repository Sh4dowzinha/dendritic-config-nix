{ den, ... }:
{
  den.aspects.applications.browsers.i2p-browser = {
    includes = [
      den.aspects.applications.browsers.librewolf
    ];

    homeManager =
      { pkgs, ... }:
      {
        programs.librewolf = {
          profiles.i2p = {
            id = 1;
            name = "i2p";
            path = "i2p";
            isDefault = false;

            settings = {
              # 1. Route all web traffic through the local i2pd HTTP proxy
              "network.proxy.type" = 1;
              "network.proxy.http" = "127.0.0.1";
              "network.proxy.http_port" = 4444;
              "network.proxy.ssl" = "127.0.0.1";
              "network.proxy.ssl_port" = 4444;
              "network.proxy.share_proxy_settings" = true;
              "network.proxy.no_proxies_on" = "127.0.0.1, localhost";

              # 2. Prevent clearnet DNS leaks and search redirection for .i2p domains
              "browser.fixup.domainsuffixwhitelist.i2p" = true;
              "keyword.enabled" = false; # Do not dispatch failed .i2p lookups to default search engine
              "network.dns.disablePrefetch" = true;
              "network.http.speculative-parallel-limit" = 0;

              # 3. Privacy, WebRTC, and fingerprinting mitigations
              "media.peerconnection.enabled" = false; # Kill WebRTC to prevent local/VPN IP leaks
              "privacy.resistFingerprinting" = true;
              "privacy.trackingprotection.enabled" = true;
              "dom.battery.enabled" = false;
            };
          };
        };

        # Dedicated desktop entry launching directly into the sandboxed i2p profile
        xdg.desktopEntries.i2p-browser = {
          name = "I2P Browser";
          genericName = "Anonymous Web Browser";
          exec = "${pkgs.librewolf}/bin/librewolf -P i2p --no-remote";
          icon = "librewolf";
          categories = [
            "Network"
            "WebBrowser"
          ];
          terminal = false;
        };
      };

    persistHome.directories = [
      ".librewolf/i2p"
    ];
  };
}
