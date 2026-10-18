{ pkgs, lib, ... }:
let
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
      id = "hlepfoohegkhhmjieoechaddaejaokhf";
      name = "Refined GitHub";
    }
  ];

  extensionsJson = pkgs.writeText "chromium-extensions.json" (builtins.toJSON lib.unique extensions);
  extensionsHash = builtins.hashString "sha256" (builtins.toJSON lib.unique extensions);

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
  apps = import ./apps.nix;
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
  ++ map (
    app:
    pkgs.writeShellScriptBin app.bin ''
      desktop_file=$(grep -l -i "^Name=${app.name}$" ~/.local/share/applications/chrome-*-Default.desktop 2>/dev/null | head -n 1)
      if [ -n "$desktop_file" ]; then
        exec $(sed -n 's/^Exec=//p' "$desktop_file") "$@"
      else
        exec chromium --profile-directory=Default --app="${app.url}" "$@"
      fi
    ''
  ) apps;
}
