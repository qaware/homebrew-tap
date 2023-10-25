#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

# Check if needed programms are installed
yq --version >/dev/null || {
    echo "yq needs to be installed"
    exit 1
}

tmpDir="/tmp/parsed-formula"

echo "Remove over-specific versions:"
for formulaVersionsFile in "$tmpDir"/*.yaml; do
    fName=$(basename "${formulaVersionsFile%.yaml}")
    echo "- $fName ($(yq 'length' "$formulaVersionsFile") versions found)"

    # Remove over-specific formula
    while read -r fVersion; do
      fFilename=$(yq -e -ot '.filename' <<<"$fVersion")

      echo "  - Removing $fFilename"
      rm -f "Formula/$fFilename"
    done < <(yq -e -oj -I0 '.[] | select(.bugfix != "" or .buildtag != "")' <"$formulaVersionsFile" 2>/dev/null)
done