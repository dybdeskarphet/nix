function __tmuxp_workspaces
    for file in ~/.config/tmuxp/*.{yaml,yml,json}
        test -f "$file"; and path change-extension "" (path basename "$file")
    end
end

function tp --description "Load a tmuxp workspace"
    tmuxp load $argv
end

complete -c tp -f -a "(__tmuxp_workspaces)"
