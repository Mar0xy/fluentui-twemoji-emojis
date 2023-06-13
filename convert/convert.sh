#!/bin/bash

set -eu

mkdir -p unicode/3d
mkdir -p unicode/color
mkdir -p unicode/flat
mkdir -p unicode/hc

first_of() {
  ls -1 "$1"/*.svg | head -n1
}

get_png() {
  filena=$(ls -1 "$1"/*.svg | head -n1)
  fuck=${filena%.*}.png
}

fuck=nothing

find fluentui-emoji/assets -name metadata.json | while read meta; do
  data=$(jq -r '. | .out = "codes=(" + .unicode + ") cldr=\"" + .cldr + "\"" | .out' "$meta")
  eval ${data}
  code=${codes[@]}
  echo ${code} ${cldr}

  src_dir=${meta%/metadata.json}
  if [ -d "${src_dir}/Default" ]; then
    src_dir="${src_dir}/Default"
  fi

  # 3D
  cp "${src_dir}/3D"/*.png "unicode/3d/$(sed 's/ /-/g' <<< "${code}").png"
  # Color
  get_png "${src_dir}/Color"
  inkscape "$(first_of "${src_dir}/Color")" --export-filename="$fuck" -w 256 -h 256 2>/dev/null |:
  mv "$fuck" "unicode/color/$(sed 's/ /-/g' <<< "${code}").png"
  # Flat
  get_png "${src_dir}/Flat"
  inkscape "$(first_of "${src_dir}/Flat")" --export-filename="$fuck" -w 256 -h 256 2>/dev/null |:
  mv "$fuck" "unicode/flat/$(sed 's/ /-/g' <<< "${code}").png"
  # High Contrast
  get_png "${src_dir}/High Contrast"
  inkscape "$(first_of "${src_dir}/High Contrast")" --export-filename="$fuck" -w 256 -h 256 2>/dev/null |:
  mv "$fuck" "unicode/hc/$(sed 's/ /-/g' <<< "${code}").png"
done
