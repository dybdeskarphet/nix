<p align="center">
    <img width="160" alt="NixOS logo" src="./assets/nix-logo.svg"/>
</p>

<p align="center">
    Personal <strong>NixOS</strong> configuration managed with Flakes, <code>flake-parts</code>, <code>import-tree</code>, and Home Manager.
</p>

<h2><img src="./assets/icon-architecture.svg" width="24" height="24" align="absmiddle" alt=""/> Architecture</h2>

- Modular `flake-parts` configuration under `modules/`, auto-imported via `import-tree` and grouped into `nixos` and `home` topic buckets in `modules/host.nix`.
- Dynamic Material You theming generated from `env.wallpaper` (`assets/wallpapers/`) via `matugen`.
- Host-specific config, hardware configuration, and `sops-nix`-encrypted secrets kept out of the repository via the private flake input (`inputs.private`).

<h2><img src="./assets/icon-usage.svg" width="24" height="24" align="absmiddle" alt=""/> Usage</h2>

Ensure your private flake input is configured and the `sops` age key is installed, then rebuild using `nh`:

```bash
# apply
nh os switch .

# test
nh os test .
```
