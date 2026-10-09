{ pkgs, lib, ... }:
{
  mkSandboxed =
    {
      pkg,
      binName ? null,
      unshareNet ? false,
      bindFiles ? true,
      roBinds ? [ ],
      rwBinds ? [ ],
      extraArgs ? [ ],
    }:
    let
      bin = if binName != null then binName else (pkg.meta.mainProgram or (lib.getName pkg));

      roBindsStr = lib.concatMapStringsSep " " (p: "--ro-bind-try '${p}' '${p}'") roBinds;
      rwBindsStr = lib.concatMapStringsSep " " (p: "--bind-try '${p}' '${p}'") rwBinds;
      extraArgsStr = lib.concatStringsSep " " extraArgs;
      netFlag = lib.optionalString unshareNet "--unshare-net";

      dynamicBinding =
        if bindFiles then
          ''
            ARGS=()
            for arg in "$@"; do
              if [ -e "$arg" ]; then
                REAL="$(realpath "$arg")"
                ARGS+=(--ro-bind "$REAL" "$REAL")
                ARGS+=(--ro-bind-try "$(dirname "$REAL")" "$(dirname "$REAL")")
              fi
            done
          ''
        else
          "ARGS=()";

      wrapped = pkgs.writeShellScriptBin bin ''
        ${dynamicBinding}

        exec ${pkgs.bubblewrap}/bin/bwrap \
          --ro-bind /nix/store /nix/store \
          --ro-bind /etc /etc \
          --dev /dev \
          --proc /proc \
          --tmpfs /tmp \
          --ro-bind-try "$XDG_RUNTIME_DIR" "$XDG_RUNTIME_DIR" \
          ${netFlag} \
          ${roBindsStr} \
          ${rwBindsStr} \
          ${extraArgsStr} \
          "''${ARGS[@]}" \
          ${pkg}/bin/${bin} "$@"
      '';
    in
    pkgs.symlinkJoin {
      name = "${pkg.name or "app"}-sandboxed";
      paths = [
        wrapped
        pkg
      ];
      meta.mainProgram = bin;
    };
}
