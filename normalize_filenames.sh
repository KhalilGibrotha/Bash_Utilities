#!/usr/bin/env bash
# Recursively rename files that match the expected pattern.
# Files are moved to the current working directory with a clean name.

set -euo pipefail

usage() {
  echo "Usage: $0 [directory]" >&2
}

target_dir="${1:-.}"
[ "$#" -gt 1 ] && { usage; exit 1; }

if [ ! -d "$target_dir" ]; then
  echo "Target directory '$target_dir' not found" >&2
  exit 1
fi

find "$target_dir" -type f -print0 | while IFS= read -r -d '' file; do
  base=$(basename "$file")
  IFS='.' read -ra parts <<< "$base"
  num=${#parts[@]}
  if (( num < 8 )); then
    echo "Skipping unmatched: $file" >&2
    continue
  fi
  idx_XXX=$(( num - 3 ))
  if [[ ${parts[idx_XXX]} != "XXX" ]]; then
    echo "Skipping unmatched: $file" >&2
    continue
  fi
  title=${parts[0]}
  date="${parts[1]}.${parts[2]}.${parts[3]}"
  subtitle_parts=("${parts[@]:4:idx_XXX-4}")
  subtitle="${subtitle_parts[*]}"
  subtitle=${subtitle//./ }
  resolution=${parts[$((num-2))]}
  extgroup=${parts[$((num-1))]}
  ext=${extgroup%%-*}
  ext=${ext,,}

  new_name="${title} ${date} ${subtitle} ${resolution}.${ext}"
  dest="./$new_name"
  if [ -e "$dest" ]; then
    echo "Skipping (exists): $dest" >&2
    continue
  fi
  mv "$file" "$dest"

done
