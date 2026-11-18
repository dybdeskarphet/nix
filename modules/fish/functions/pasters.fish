function pasters --description 'Upload file or stdin to paste.rs'
    set -l file /dev/stdin
    if test (count $argv) -gt 0
        set file $argv[1]
    end

    curl --data-binary @$file https://paste.rs
end
