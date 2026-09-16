#!/bin/bash

script_name="$(basename "$0")"

colors_match() {
  T='ABC' # The text for the color test

  echo -e "\n          def      40m      41m      42m      43m      44m      45m      46m      47m"

  for FGs in '    m' '   1m' '  30m' '1;90m' '  31m' '1;91m' '  32m' \
    '1;92m' '  33m' '1;93m' '  34m' '1;94m' '  35m' '1;95m' \
    '  36m' '1;96m' '  37m' '1;97m'; do

    FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "

    for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
      echo -en " \033[$FG\033[$BG  $T  \033[0m"
    done
    echo
  done
  echo
}

colors() {
  # Initialize standard and bright colors 0-7 dynamically
  for i in {0..7}; do
    printf -v "f$i" %b "\e[3${i}m"
    printf -v "fbright$i" %b "\e[9${i}m"
  done

  d=$'\e[1m'
  t=$'\e[0m'

  echo "" # Top padding

  # Top row of blocks (with highlight)
  for i in {1..7} 0; do
    fg="f$i"
    bfg="fbright$i"
    printf "%s███%s%s▄%s  " "${!fg}" "$d" "${!bfg}" "$t"
  done
  printf "\n"

  # Middle rows of blocks
  for _ in 1 2; do
    for i in {1..7} 0; do
      fg="f$i"
      bfg="fbright$i"
      printf "%s███%s%s█%s  " "${!fg}" "$d" "${!bfg}" "$t"
    done
    printf "\n"
  done

  # Bottom row of blocks (shadows)
  for i in {1..7} 0; do
    bfg="fbright$i"
    printf "%s%s ▀▀▀%s  " "$d" "${!bfg}" "$t"
  done
  printf "\n\n"
}

print_usage() {
  printf '\n%b\n' "  \e[1mCOLORS\e[0m"
  printf '%b\n' "  $script_name {-C --colors2}  show colors in different backgrounds"
  printf '%b\n\n' "  $script_name {-c --colors}   show colors"
}

case $1 in
--colors | -c) colors ;;
--colors2 | -C) colors_match ;;
*) print_usage ;;
esac
