#!/bin/bash

dir=$1
path=$2

mime=$(file --brief --mime-type -- "$path")

case "$mime" in
  image/*) ;;
  video/*) ;;
  *)      exit 1 ;;
esac

name=$(basename -- "$path")
name=${name//_/-}
parent=$(basename -- "$(dirname "$path")")
parent=${parent//_/-}
date=$(exiftool -s3 -f -d '%Y-%m-%d %H:%M:%S' -CreateDate "$path")

case "$date" in
  -|'0000:00:00 00:00:00'|'')
    date='1970-01-01'
    ;;
esac

year=$(date -d "$date" '+%Y')
month=$(date -d "$date" '+%m')
day=$(date -d "$date" '+%d')

mkdir -p -- "$dir/$year/$month"
n=1
target="$dir/$year/$month/${day}_${n}_${parent}_${name}"

while [[ -e "$target" || -L "$target" ]]; do
  if cmp -s -- "$path" "$target"; then
    exit 0
  fi
  ((n++))
  target="$dir/$year/$month/${day}_${n}_${parent}_${name}"
done

ln -- "$path" "$target"

