function fish_command_not_found
    set -l cmd $argv[1]
    set -l pkgs (nix-locate --minimal --no-group --type x --type s --whole-name --at-root "/bin/$cmd" 2>/dev/null)

    if test -n "$pkgs"
        echo "The program '$cmd' is available in:" >&2
        for pkg in $pkgs
            echo "  $pkg" >&2
        end
        echo "" >&2

        if status is-interactive
            read -l -P "Run with comma (, $argv)? [y/N] " confirm
            if test "$confirm" = y -o "$confirm" = Y
                , $argv
                return $status
            end
        else
            echo "Run it with: , $argv" >&2
        end
    else
        echo "$cmd: command not found" >&2
    end

    return 127
end
