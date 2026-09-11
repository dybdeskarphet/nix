function clean_home
    if test "$PWD" != "$HOME"
        return
    end

    set -l DESKTOP_DIR (xdg-user-dir DESKTOP)

    set -l files
    for f in ~/*
        if test -f "$f"
            set -a files (basename "$f")
        end
    end

    if test (count $files) -eq 0
        set_color green
        echo "Home is already clean!"
        set_color normal
        return
    end

    echo ""
    set_color white --dim
    for file in $files
        echo "  $file"
    end
    set_color normal

    echo ""

    set -l prompt_msg (set_color normal)"Are at "(set_color cyan --bold)"$HOME"(set_color normal)", do you want to move them to "(set_color cyan --bold)"$DESKTOP_DIR"(set_color normal)" (y/N)? "

    read -l -P "$prompt_msg" confirm

    if string match -ri 'y|yes' -- "$confirm" >/dev/null
        mkdir -p "$DESKTOP_DIR"
        for file in $files
            mv -i "$HOME/$file" "$DESKTOP_DIR"
        end
        set_color green
        echo "Moved to $DESKTOP_DIR"
        set_color normal
    else
        set_color red
        echo "No files were moved"
        set_color normal
    end
end

function r
    clean_home
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -l cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
