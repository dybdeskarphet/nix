function esupport
    set ESUPPORT (sudo dmidecode -t system | grep Serial | sed 's/.*:\ //g')
    echo $ESUPPORT | wl-copy
    echo "Copied to clipboard: $ESUPPORT"
end
