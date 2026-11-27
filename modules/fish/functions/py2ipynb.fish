function py2ipynb --description 'Convert script to notebook and execute via uvx'
    if test (count $argv) -eq 0
        echo "Usage: py2ipynb <file>" >&2
        return 1
    end

    if not test -f "$argv[1]"
        echo "Error: File '$argv[1]' not found." >&2
        return 1
    end

    command uvx jupytext --set-kernel - --to notebook --execute "$argv[1]"
end
