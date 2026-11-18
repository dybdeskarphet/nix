function ytgetplaylist --description "Print the playlist items of a yt-dlp supporting playlist" --wraps yt-dlp
    yt-dlp --flat-playlist --print title $argv
end
