#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

function generateToc() {
  echo "* TODO"
  return
#  while read -r file; do
#    adrNumber=$(cut -d- -f1 <<<"$file")
#    adrTitle=$(sed '/---/,/---/d' "$file" | sed -En 's/^# (.+)$/\1/p' | head -1)
#    1>&2 echo "  - $file => ($adrNumber) $adrTitle"
#    printf -- "* [ADR-%s](%s) - %s\n" "$adrNumber" "$file" "$adrTitle"
#  done < <(find . -maxdepth 1 -type f -regex '\./[0-9]+-.*\.md' -exec basename {} \; | sort)
}

echo "Generating TOC in README.md"
# https://stackoverflow.com/questions/2699666/replace-delimited-block-of-text-in-file-with-the-contents-of-another-file
sed -i -ne '/<!-- BEGIN TOC -->/ {p; r '<(generateToc) -e ':a; n; /<!-- END TOC -->/ {p; b}; ba}; p' README.md
