EXTENSIONS_FILE="@extensionsJson@"
CHROMIUM_VERSION="@chromiumVersion@"
JQ="@jq@"

PREFS="$HOME/.config/chromium/Default/Preferences"

echo "Checking extensions for ungoogled-chromium..."

MISSING=()
if [ -f "$EXTENSIONS_FILE" ]; then
  while IFS=$'\t' read -r id name; do
    if [ -f "$PREFS" ] && "$JQ" -e --arg id "$id" '.extensions.settings[$id] != null' "$PREFS" >/dev/null 2>&1; then
      echo "  ✓ $name is installed"
    else
      echo "  ➜ Missing: $name"
      MISSING+=("https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${CHROMIUM_VERSION}&x=id%3D${id}%26installsource%3Dondemand%26uc")
    fi
  done < <("$JQ" -r '.[] | "\(.id)\t\(.name)"' "$EXTENSIONS_FILE")
fi

if [ "${#MISSING[@]}" -eq 0 ]; then
  echo "All configured extensions are installed!"
else
  echo "Prompting ${#MISSING[@]} missing extension(s) in Chromium..."
  chromium "${MISSING[@]}" &
fi
