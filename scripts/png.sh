#!/bin/bash

set -eu

find fluentui-emoji/assets -name metadata.json | while read meta; do
  data=$(jq -r '. | .out = "codes=(" + .unicode + ") cldr=\"" + .cldr + "\"" | .out' "${meta}")
  eval ${data}
  code=${codes[0]}
  echo ${code} ${cldr}
  src_dir=${meta%/metadata.json}
  dst_dir=unicode/${code}
  mkdir -p ${dst_dir}

  if [ -d "${src_dir}/Default" ]; then
    src_dir="${src_dir}/Default"
  fi

  # 3D
  cp "${src_dir}/3D"/*.png ${dst_dir}/3d.png
  # Color
  convert -resize 256x256 -background none "${src_dir}/Color"/*.svg ${dst_dir}/color.png
  # Flat
  convert -resize 256x256 -background none "${src_dir}/Flat"/*.svg ${dst_dir}/flat.png
  # High Contrast
  convert -resize 256x256 -background none "${src_dir}/High Contrast"/*.svg ${dst_dir}/hc.png
done
