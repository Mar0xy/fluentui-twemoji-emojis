#!/bin/bash

set -eu

mkdir -p unicode/3d
mkdir -p unicode/color
mkdir -p unicode/flat
mkdir -p unicode/hc

first_of() {
  ls -1 "$1"/*.svg | head -n1
}

find fluentui-emoji/assets -name metadata.json | while read meta; do
  data=$(jq -r '. | .out = "codes=(" + .unicode + ") cldr=\"" + .cldr + "\"" | .out' "${meta}")
  eval ${data}
  code=${codes[0]}
  echo ${code} ${cldr}

  src_dir=${meta%/metadata.json}
  if [ -d "${src_dir}/Default" ]; then
    src_dir="${src_dir}/Default"
  fi

  # 3D
  cp "${src_dir}/3D"/*.png unicode/3d/${code}.png
  # Color
  convert/svg2png <"$(first_of "${src_dir}/Color")" >unicode/color/${code}.png
  # Flat
  convert/svg2png <"$(first_of "${src_dir}/Flat")" >unicode/flat/${code}.png
  # High Contrast
  convert/svg2png <"$(first_of "${src_dir}/High Contrast")" >unicode/hc/${code}.png
done
