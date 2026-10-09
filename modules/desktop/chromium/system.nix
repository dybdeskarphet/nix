{ ... }:
{
  programs.chromium = {
    enable = true;

    initialPrefs = {
      extensions.theme = {
        system_theme = 1; # GTK theme
        use_system = true;
      };
    };

    extraOpts = {
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "RestoreOnStartup" = 5;
      "ShowHomeButton" = false;
      "HighEfficiencyModeEnabled" = true;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "DoNotTrack" = true;
      "PromptForDownloadLocation" = false;

      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "MetricsReportingEnabled" = false;
      "TranslateEnabled" = false;
      "NetworkPredictionOptions" = 1;

      "WebRtcIPHandlingPolicy" = "disable_non_proxied_udp";
      "HttpsOnlyMode" = "force_enabled";

      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "Google";
      "DefaultSearchProviderKeyword" = "google.com";
      "DefaultSearchProviderSearchURL" = "https://www.google.com/search?q={searchTerms}";
      "DefaultSearchProviderSuggestURL" =
        "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
    };
  };
}
