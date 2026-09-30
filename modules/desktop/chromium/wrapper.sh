REAL_CHROMIUM="@realChromium@"
EXTENSIONS_FILE="@extensionsJson@"
EXTENSIONS_HASH="@extensionsHash@"
CHROMIUM_VERSION="@chromiumVersion@"
JQ="@jq@"

MARKER="$HOME/.config/chromium/.extensions_prompted"
PREFS="$HOME/.config/chromium/Default/Preferences"

for arg in "$@"; do
  case "$arg" in
    --app=*|--version|-v|--help|-h)
      exec "$REAL_CHROMIUM" "$@"
      ;;
  esac
done

if [ -f "$MARKER" ] && [ "$(< "$MARKER")" = "$EXTENSIONS_HASH" ]; then
  exec "$REAL_CHROMIUM" "$@"
fi

URLS=()
if [ -f "$EXTENSIONS_FILE" ]; then
  while IFS= read -r id; do
    if ! [ -f "$PREFS" ] || ! "$JQ" -e --arg id "$id" '.extensions.settings[$id] != null' "$PREFS" >/dev/null 2>&1; then
      URLS+=("https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${CHROMIUM_VERSION}&x=id%3D${id}%26installsource%3Dondemand%26uc")
    fi
  done < <("$JQ" -r '.[].id' "$EXTENSIONS_FILE")
fi

mkdir -p "$HOME/.config/chromium"
echo "$EXTENSIONS_HASH" > "$MARKER"

if [ "${#URLS[@]}" -gt 0 ]; then
  exec "$REAL_CHROMIUM" "$@" "${URLS[@]}"
else
  exec "$REAL_CHROMIUM" "$@"
fi
