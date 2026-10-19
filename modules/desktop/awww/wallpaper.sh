image="${1:-}"

if [ -z "$image" ] || [ ! -f "$image" ]; then
  echo "Usage: wallpaper <path-to-image>" >&2
  exit 1
fi

awww img -n bg --transition-fps 100 --transition-type center "$image"

cache_dir="${HOME}/img"
mkdir -p "$cache_dir"
blur_img="$cache_dir/.wallpaper_blur.png"
lock_img="$cache_dir/.wallpaper_lock.png"

ffmpeg -y -i "$image" \
  -vf "scale=iw/4:-1,gblur=sigma=20:steps=2,eq=brightness=-0.05,scale=4*iw:-1" \
  -update 1 -frames:v 1 "$blur_img" -loglevel error

ffmpeg -y -i "$image" -filter_complex "
  [0:v]split=3[orig][blur_in][mask_in];
  [blur_in]boxblur=25:3,eq=brightness=-0.05[blurred];
  [mask_in]scale=iw:1,format=gray,geq=lum='255*(1 - 3*pow(clip((X-W*0.20)/(W*0.25),0,1),2) + 2*pow(clip((X-W*0.20)/(W*0.25),0,1),3))'[mask_1d];
  [mask_1d][blurred]scale2ref=w=ref_w:h=ref_h:flags=bilinear[mask][blurred_ref];
  [blurred_ref][mask]alphamerge[blurred_alpha];
  [orig][blurred_alpha]overlay=0:0:format=auto[out]
" -map "[out]" -update 1 -frames:v 1 "$lock_img" -loglevel error

awww img -n backdrop --transition-fps 100 --transition-type center "$blur_img"
