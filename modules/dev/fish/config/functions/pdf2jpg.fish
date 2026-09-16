function pdf2jpg --description 'Convert and vertically append PDF pages into a single JPG'
    if test (count $argv) -eq 0
        echo "Usage: pdf2jpg <file.pdf>" >&2
        return 1
    end

    set -l pdf_file $argv[1]

    if not test -f "$pdf_file"
        echo "Error: File '$pdf_file' not found." >&2
        return 1
    end

    set -l base_name (string replace -r '\.[^.]*$' '' -- $pdf_file)
    convert -density 600 "$pdf_file" -append -quality 100 "$base_name.jpg"
end
