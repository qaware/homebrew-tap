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

aliasesCountBefore=$((ls -1 Aliases/*.rb 2>/dev/null || true) | wc -l | tr -d ' ')
echo "Found $aliasesCountBefore aliases beforehand"

# TODO: Use search for symlinks and delete instead of plain rm
echo "Delete symlinks in Aliases folder"
rm -f Aliases/*.rb

echo "Generating Aliases from provided config:"
for formulaVersionsFile in "$tmpDir"/*.yaml; do
    formulaName=$(basename "${formulaVersionsFile%.yaml}")
    echo "- $formulaName ($(yq 'length' "$formulaVersionsFile") versions found)"
    echo "TODO: Do magic and create the Alias symlink files"
    # ln -s foo bar

    # TODO: Set latest => $formulaName.rb
    # TODO: Set Majors => $formulaName@$major.rb
    # TODO: Set Majors.Minors => $formulaName@$major.$minor.rb
done

aliasesCountAfter=$((ls -1 Aliases/*.rb 2>/dev/null || true) | wc -l | tr -d ' ')
echo "Found $aliasesCountAfter aliases afterwards -- a change of $((aliasesCountAfter - aliasesCountBefore))"
