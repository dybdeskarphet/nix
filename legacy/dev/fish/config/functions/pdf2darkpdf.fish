function pdf2darkpdf --description 'Invert PDF colors to dark mode'
    if test (count $argv) -eq 0
        echo "Usage: pdf2darkpdf <file.pdf>" >&2
        return 1
    end

    set -l filepath $argv[1]

    if not test -f "$filepath"
        echo "Error: File '$filepath' not found." >&2
        echo "Usage: pdf2darkpdf <file.pdf>" >&2
        return 1
    end

    set -l basename (string replace -r '\.[^.]*$' '' -- $filepath)
    set -l outname "$basename"_dark.pdf

    set -l tmpdir (mktemp -d)

    convert -density 500 "$filepath" \
        -background white -alpha remove -alpha off \
        -negate -quality 100 "$tmpdir/page-%04d.png"
    and convert "$tmpdir/page-"*.png "$outname"

    rm -rf "$tmpdir"
end
