{
  den.aspects.applications.messaging.thunderbird = {
    nixos = {
      programs.thunderbird = {
        enable = true;

        policies = {
          DisableTelemetry = true;
          DisableAppUpdate = true;
          DontCheckDefaultClient = true;
        };

        # Sets sane defaults in /etc/thunderbird without locking the GUI
        preferencesStatus = "default";
        preferences = {
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
