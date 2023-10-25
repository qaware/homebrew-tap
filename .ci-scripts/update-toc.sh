#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

function generateToc() {
  programNameList=()

  while read -r file; do
    # shellcheck disable=SC2001
    programName=$(sed -E 's/(@.+)?\.rb//g' <<<"$file")
    programNameList+=("$programName")
  done < <(find "Formula" -maxdepth 1 -type f -name '*.rb' -exec basename {} \; | sort)

  printf "* %s\n" "${programNameList[@]}" | sort -u
}

echo "Generating TOC in README.md"
toc=$(generateToc)
echo "$toc"
# https://stackoverflow.com/questions/2699666/replace-delimited-block-of-text-in-file-with-the-contents-of-another-file
sed -i -ne '/<!-- BEGIN TOC -->/ {p; r '<<<"$toc" -e ':a; n; /<!-- END TOC -->/ {p; b}; ba}; p' README.md
