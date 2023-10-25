#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

TAP_GEN_TMP_PATH=".parsed-formula"

# Check if needed programms are installed
yq --version >/dev/null || {
    echo "yq needs to be installed"
    exit 1
}

echo "Remove over-specific versions:"
while read -r formulaVersionsFile; do
    fName=$(basename "${formulaVersionsFile%.yaml}")
    echo "- $fName ($(yq 'length' "$formulaVersionsFile") versions)"

    # Remove over-specific formula
    while read -r fVersion; do
      fFilename=$(yq -e -ot '.filename' <<<"$fVersion")

      echo "  - Removing $fFilename"
      rm -f "Formula/$fFilename"
    done < <(yq -e -oj -I0 '.[] | select(.bugfix != "" or .buildtag != "")' <"$formulaVersionsFile" 2>/dev/null)
done < <(find "$TAP_GEN_TMP_PATH" -maxdepth 1 -type f -name '*.yaml')
