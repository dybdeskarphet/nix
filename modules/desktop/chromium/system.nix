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

    extraOptsRecommended = {
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "RestoreOnStartup" = 1;
      "ShowHomeButton" = false;
      "HighEfficiencyModeEnabled" = true;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "DoNotTrack" = true;
      "PromptForDownloadLocation" = false;

      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "Google";
      "DefaultSearchProviderKeyword" = "google.com";
      "DefaultSearchProviderSearchURL" = "https://www.google.com/search?q={searchTerms}";
      "DefaultSearchProviderSuggestURL" =
        "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
    };
  };
}
