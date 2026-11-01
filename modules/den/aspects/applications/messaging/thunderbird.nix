{
  den.aspects.applications.messaging.thunderbird = {
    homeManager = {
      programs.thunderbird = {
        enable = true;
        languagePacks = [
          "en-US"
          "pt-PT"
        ];

        policies = {
          DisableTelemetry = true;
          DisableAppUpdate = true;
          DisableFirefoxAccounts = true;
        };

        settings = {
          # Kill onboarding & nagging
          "mailnews.start_page.enabled" = false;
          "mail.shell.checkDefaultClient" = false;
          "app.donation.eoy.version.viewed" = 999;

          # Privacy (block tracking pixels & telemetry)
          "mailnews.message_display.disable_remote_image" = true;
          "privacy.donottrackheader.enabled" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;

          # Convenience (newest emails on top, spellcheck before send)
          "mailnews.default_sort_type" = 18;
          "mailnews.default_sort_order" = 2;
          "mail.SpellCheckBeforeSend" = true;
          "mail.biff.play_sound" = false;
        };
      };
    };

    persistHome.directories = [
      {
        directory = ".config/thunderbird";
        mode = "0700";
      }
    ];
  };
}
