#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

# Check if needed programms are installe
yq --version >/dev/null || {
    echo "yq needs to be installed"
    exit 1
}

tmpDir="/tmp/parsed-formula"

# TODO: Use search for symlinks and delete instead of plain rm
echo "Delete symlinks in Alaises folder"
rm -f Alises/*.rb

echo "Generating Aliases from provided config:"
for formulaVersionsFile in $(ls -l1 "$tmpDir"/*.yaml); do
    echo "- $(basename "$formulaVersionsFile") ($(yq 'length' "$formulaVersionsFile") versions found)"
    echo "TODO: Do magic and create the Alias symlink files"
    # ln -s foo bar
done
