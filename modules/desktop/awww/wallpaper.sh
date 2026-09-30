image="''${1:-}"

if [ -z "$image" ] || [ ! -f "$image" ]; then
  echo "Usage: wallpaper <path-to-image>" >&2
  exit 1
fi

awww img -n bg --transition-fps 100 --transition-type center "$image"

cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/awww"
mkdir -p "$cache_dir"
blur_img="$cache_dir/backdrop.png"

ffmpeg -y -i "$image" \
  -vf "scale=iw/4:-1,gblur=sigma=20:steps=2,eq=brightness=-0.05,scale=4*iw:-1" \
  -update 1 -frames:v 1 "$blur_img" -loglevel error

awww img -n backdrop --transition-fps 100 --transition-type center "$blur_img"
