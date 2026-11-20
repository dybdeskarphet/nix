{ ... }:
{
  nixos.gui =
    {
      pkgs,
      pkgs-small,
      lib,
      config,
      colors,
      ...
    }:
    let
      # PWAs {{{
      apps = [
        {
          bin = "google-meet";
          name = "Google Meet";
          url = "https://meet.google.com";
        }
        {
          bin = "instagram";
          name = "Instagram";
          url = "https://instagram.com";
        }
        {
          bin = "gemini";
          name = "Gemini";
          url = "https://gemini.google.com";
        }
      ];

      pwaWrappers = map (
        app:
        pkgs.writeShellScriptBin app.bin ''
          desktop_file=$(grep -l -i "^Name=${app.name}$" "$HOME"/.local/share/applications/{chrome,brave}-*-Default.desktop 2>/dev/null | head -n 1 || true)
          if [ -n "$desktop_file" ]; then
            exec_line=$(sed -n 's/^Exec=//p' "$desktop_file" | head -n 1)
            eval "exec $exec_line \"\$@\""
          else
            exec brave --profile-directory=Default --app="${app.url}" "$@"
          fi
        ''
      ) apps;
      # }}}
    in
    {
      # Brave Package, Extensions & Policies {{{
      programs.brave = {
        enable = true;

        package = pkgs-small.brave.override {
          commandLineArgs = lib.concatStringsSep " " [
            "--enable-features=BraveTreeTab"
            "--ozone-platform=wayland"
            "--enable-gpu-rasterization"
            "--enable-zero-copy"
          ];
        };

        extensions = [
          "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
          "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "jplgfhpmjnbigmhklmmbgecoobifkmpa" # Proton VPN
          "oocalimimngaihdkbihfgmpkcpnmlaoa" # Teleparty
          "ekhagklcjbdpajgpjgmbionohlpdbjgc" # Zotero Connector
          "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC-Browser
          "lpgajkhkagnpdjklmpgjeplmgffnhhjj" # Trim
          "jinjaccalgkegednnccohejagnlnfdag" # Violentmonkey
          "mmioliijnhnoblpgimnlajmefafdfilb" # Shazam
          "hlepfoohegkhhmjieoechaddaejaokhf" # Refined GitHub
          "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
        ];

        policies = {
          # Brave bloat elimination
          "BraveRewardsDisabled" = true;
          "BraveWalletDisabled" = true;
          "BraveVPNDisabled" = true;
          "BraveAIChatEnabled" = false;
          "BraveNewsDisabled" = true;
          "BraveTalkDisabled" = true;
          "BravePlaylistEnabled" = false;
          "TorDisabled" = true;
          "BraveWaybackMachineEnabled" = false;

          # Privacy & telemetry
          "BraveStatsPingEnabled" = false;
          "BraveP3AEnabled" = false;
          "BraveWebDiscoveryEnabled" = false;
          "DefaultBraveFingerprintingV2Setting" = 3;
          "BrowserSignin" = 0;
          "SyncDisabled" = true;
          "MetricsReportingEnabled" = false;
          "UrlKeyedAnonymizedDataCollectionEnabled" = false;
          "PrivacySandboxPromptEnabled" = false;
          "DoNotTrack" = true;
          "PaymentMethodQueryEnabled" = false;
          "WebRtcIPHandlingPolicy" = "disable_non_proxied_udp";
          "HttpsOnlyMode" = "force_enabled";
          "BuiltInDnsClientEnabled" = false;

          # Browser behavior & UI
          "BrowserThemeColor" = colors.surface_container;
          "BookmarkBarEnabled" = false;
          "BackgroundModeEnabled" = false;
          "TabHoverCardImagesEnabled" = false;
          "ShoppingListEnabled" = false;
          "PasswordManagerEnabled" = false;
          "SpellcheckEnabled" = true;
          "SpellcheckLanguage" = [
            "en-US"
            "tr"
          ];
          "RestoreOnStartup" = 5;
          "ShowHomeButton" = false;
          "HighEfficiencyModeEnabled" = true;
          "AutofillAddressEnabled" = false;
          "AutofillCreditCardEnabled" = false;
          "PromptForDownloadLocation" = false;
          "DownloadDirectory" = config.home-manager.users.skarphet.xdg.userDirs.download;
          "TranslateEnabled" = false;
          "NetworkPredictionOptions" = 1;

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
      # }}}

      # Initial Preferences & PWA Launchers {{{
      environment.etc."brave/initial_preferences".text = builtins.toJSON {
        extensions.theme = {
          system_theme = 0;
          use_system = false;
        };
        brave = {
          sidebar.sidebar_show_option = 3;
          show_side_panel_button = false;
        };
      };

      environment.systemPackages = pwaWrappers;
      # }}}
    };
}

# -- vim: fdm=marker fdl=0
