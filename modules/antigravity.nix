{ inputs, ... }:
{
  home.cli =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.antigravity-cli = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli;
        mutableSettings = true;
        settings = {
          colorScheme = "terminal";
          altScreenMode = "default";
          toolPermission = "request-review";
          artifactReviewPolicy = "asks-for-review";
        };

        permissions = {
          allow = [
            "command(git status)"
            "command(git diff)"
            "command(git log)"
            "command(nix flake check)"
            "command(nix eval)"
            "command(nix-instantiate --parse)"
            "read_file(/nix/store/*)"
            "read_url(nixos.org)"
            "read_url(wiki.nixos.org)"
            "read_url(github.com)"
          ];
          ask = [
            "command(git push)"
            "command(git reset)"
            "command(nixos-rebuild)"
            "command(rm )"
          ];
          deny = [
            "command(rm -rf /)"
            "command(sudo )"
            "write_file(/etc/*)"
            "read_file(~/.ssh/*)"
          ];
        };

        mcpServers = {
          nixos = {
            command = lib.getExe pkgs.mcp-nixos;
          };

          context7 = {
            command = lib.getExe' pkgs.bun "bunx";
            args = [
              "-y"
              "@upstash/context7-mcp"
            ];
          };

          serena = {
            command = lib.getExe' pkgs.uv "uvx";
            args = [
              "--from"
              "git+https://github.com/oraios/serena"
              "serena"
              "start-mcp-server"
            ];
          };
        };

        context = {
          AGENTS = ''
            - Clarify ambiguous intent briefly before acting instead of guessing.
            - Do not create or edit files unless explicitly asked; answer and discuss in chat when a prompt is exploratory.
            - Read relevant local files, configs, and errors before proposing fixes, and keep responses concise and unembellished.
          '';
        };
      };
    };
}
