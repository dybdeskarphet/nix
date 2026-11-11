{ ... }:
let
  apps = import ./apps.nix;
in
{
  environment.etc."brave/policies".source = "/etc/chromium/policies";
  environment.etc."brave/initial_preferences".source = "/etc/chromium/initial_preferences";

  programs.chromium = {
    enable = true;

    initialPrefs = {
      extensions.theme = {
        system_theme = 1; # GTK theme
        use_system = true;
      };
      brave = {
        tabs = {
          vertical_tabs_enabled = true;
          tree_tabs_enabled = true;
          vertical_tabs_floating_enabled = true;
          vertical_tabs_expanded_state_per_window = false;
          vertical_tabs_hide_completely_when_collapsed = false;
        };
        sidebar.sidebar_show_option = 3; # Never
        show_side_panel_button = false;
      };
      vertical_tabs.collapsed_state = true;
    };

    extraOpts = {
      # Brave bloat elimination
      "BraveRewardsDisabled" = true;
      "BraveWalletDisabled" = true;
      "BraveVPNDisabled" = true;
      "BraveAIChatEnabled" = false;

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
      "WebAppInstallForceList" = map (app: {
        inherit (app) url;
        default_launch_container = "window";
        create_desktop_shortcut = true;
        fallback_app_name = app.name;
      }) apps;
    };
  };
}
