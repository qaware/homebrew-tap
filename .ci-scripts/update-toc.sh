#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

TAP_GEN_TMP_PATH=".parsed-formula"

function generateToc() {
  while read -r file; do
    formulaName=${file//.yaml/}
    1>&2 echo "  - $formulaName"
    printf -- "* %s\n" "$formulaName"
  done < <(find "$TAP_GEN_TMP_PATH" -maxdepth 1 -type f -regex '.*\.yaml' -exec basename {} \; | sort)
}

echo "Generating TOC in README.md"
# https://stackoverflow.com/questions/2699666/replace-delimited-block-of-text-in-file-with-the-contents-of-another-file
sed -i -ne '/<!-- BEGIN TOC -->/ {p; r '<(generateToc) -e ':a; n; /<!-- END TOC -->/ {p; b}; ba}; p' README.md
