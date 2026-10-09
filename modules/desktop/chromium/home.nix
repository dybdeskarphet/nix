{ pkgs, lib, ... }:
let
  webApps = {
    google-meet = {
      name = "Google Meet";
      url = "https://meet.google.com";
      icon = "google-meet";
    };
  };

  chromiumWebStore = pkgs.fetchFromGitHub {
    owner = "NeverDecaf";
    repo = "chromium-web-store";
    rev = "v1.5.5.4";
    hash = "sha256-Hsk3bh4AYWCYyK8JJjWV1gcdQTrdzTODQithRHeCzu8=";
  };

  extensions = [
    {
      id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
      name = "uBlock Origin Lite";
    }
    {
      id = "dbepggeogbaibhgnhhndojpepiihcmeb";
      name = "Vimium";
    }
    {
      id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      name = "Dark Reader";
    }
    {
      id = "jplgfhpmjnbigmhklmmbgecoobifkmpa";
      name = "Proton VPN";
    }
    {
      id = "oocalimimngaihdkbihfgmpkcpnmlaoa";
      name = "Teleparty";
    }
    {
      id = "ekhagklcjbdpajgpjgmbionohlpdbjgc";
      name = "Zotero Connector";
    }
    {
      id = "oboonakemofpalcgghocfoadofidjkkk";
      name = "KeePassXC-Browser";
    }
    {
      id = "lpgajkhkagnpdjklmpgjeplmgffnhhjj";
      name = "Trim";
    }
    {
      id = "jinjaccalgkegednnccohejagnlnfdag";
      name = "Violentmonkey";
    }
    {
      id = "mmioliijnhnoblpgimnlajmefafdfilb";
      name = "Shazam";
    }
    {
      id = "dbepggeogbaibhgnhhndojpepiihcmeb";
      name = "Vimium";
    }
    {
      id = "lpgajkhkagnpdjklmpgjeplmgffnhhjj";
      name = "Trim";
    }
  ];

  extensionsJson = pkgs.writeText "chromium-extensions.json" (builtins.toJSON extensions);
  extensionsHash = builtins.hashString "sha256" (builtins.toJSON extensions);

  rawChromium =
    (pkgs.ungoogled-chromium.override {
      enableWideVine = true;
    }).override
      {
        commandLineArgs = lib.concatStringsSep " " [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
          "--extension-mime-request-handling=always-prompt-for-install"
          "--load-extension=${chromiumWebStore}/src"
        ];
      };

  chromiumWrapper = pkgs.writeShellScript "chromium" (
    builtins.readFile (
      pkgs.replaceVars ./wrapper.sh {
        realChromium = "${rawChromium}/bin/chromium";
        inherit extensionsJson extensionsHash;
        chromiumVersion = pkgs.ungoogled-chromium.version;
        jq = "${pkgs.jq}/bin/jq";
      }
    )
  );

  wrappedChromium = pkgs.symlinkJoin {
    name = "chromium";
    paths = [ rawChromium ];
    postBuild = ''
      rm "$out/bin/chromium" "$out/bin/chromium-browser"
      ln -s ${chromiumWrapper} "$out/bin/chromium"
      ln -s chromium "$out/bin/chromium-browser"
    '';
  };

  installExtensionsScript = pkgs.writeShellScriptBin "chromium-install-extensions" (
    builtins.readFile (
      pkgs.replaceVars ./install-extensions.sh {
        inherit extensionsJson;
        chromiumVersion = pkgs.ungoogled-chromium.version;
        jq = "${pkgs.jq}/bin/jq";
      }
    )
  );
in
{
  programs.chromium = {
    enable = true;
    package = wrappedChromium;
    commandLineArgs = [ ];
  };

  home.packages = [
    installExtensionsScript
  ]
  ++ lib.mapAttrsToList (
    bin: app:
    pkgs.writeShellScriptBin bin ''
      exec chromium --profile-directory=Default --app="${app.url}" "$@"
    ''
  ) webApps;

  xdg.desktopEntries = builtins.mapAttrs (bin: app: {
    name = app.name;
    exec = bin;
    icon = app.icon or "chromium";
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "Application"
    ];
  }) webApps;
}
