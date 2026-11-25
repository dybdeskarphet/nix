function sops-key-init --description "Derive root sops age key from an Ed25519 SSH private key"
    if test (count $argv) -ne 1; or not test -f "$argv[1]"
        echo "Usage: sops-key-init <path-to-ed25519-private-key>" >&2
        return 1
    end

    set -l ssh_key $argv[1]
    set -l key_dir /root/.config/sops/age
    set -l key_file "$key_dir/keys.txt"

    set -l derived (ssh-to-age -private-key -i "$ssh_key")
    or return 1

    sudo mkdir -p "$key_dir"
    and sudo chmod 700 "$key_dir"
    and printf '%s\n' "$derived" | sudo tee "$key_file" >/dev/null
    and sudo chmod 600 "$key_file"
    or return 1

    echo "Installed sops age key at $key_file"
    echo -n "Public key: "
    sudo age-keygen -y "$key_file"
end
