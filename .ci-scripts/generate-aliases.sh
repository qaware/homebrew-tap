#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

# Functions

function createSymlink() {
  if [[ -z "$1" ]]; then
    echo "Arg1 was empty"
    exit 1
  fi
  if [[ -z "$2" ]]; then
    echo "Arg2 was empty"
    exit 1
  fi
  # Go to subfolder and create symlink
  (
    cd Aliases
    ln -s "../Formula/$1" "$2"
  )
}

# CODE

# Check if needed programms are installed
yq --version >/dev/null || {
    echo "yq needs to be installed"
    exit 1
}

tmpDir="/tmp/parsed-formula"

aliasesCountBefore=$( (ls -1 Aliases/*.rb 2>/dev/null || true) | wc -l | tr -d ' ')
echo "Found $aliasesCountBefore aliases beforehand"

# TODO: Use search for symlinks and delete instead of plain rm
echo "Delete symlinks in Aliases folder"
rm -f Aliases/*.rb

echo "Generating Aliases from provided config:"
for formulaVersionsFile in "$tmpDir"/*.yaml; do
    fName=$(basename "${formulaVersionsFile%.yaml}")
    echo "- $fName ($(yq 'length' "$formulaVersionsFile") versions found)"

    # Check for valid object
    test -n "$(yq -ot '[.[] | .bugfix + .buildtag | select(. != "")] | join(";")' "$formulaVersionsFile")" && {
      echo "ERROR! INVALID INPUT! Bugfix or Buildtag field is set, parse-formulas must be buggy!"
      exit 1
    }

    # Create latest if does not exists
    if [[ ! -f "Formula/$fName.rb" ]]; then
      # Get latest version
      latestMajor=$(yq -ot \
        '[.[] | .major] | unique | sort | .[-1] // ""' \
        "$formulaVersionsFile")
      latestMinor=$(yq -ot \
        '[.[] | select(.major == "'"$latestMajor"'") | .minor] | unique | sort | .[-1] // ""' \
        "$formulaVersionsFile")

      if [[ -z "$latestMajor" ]]; then
        echo "WARNING! Major was empty ($latestMajor) => Must be a bug"
        exit 1
      fi

      # Prepend dot if latest minor is not empty
      test -n "$latestMinor" && latestMinor=".$latestMinor"

      # Build symlink names and create it
      symlinkName="$fName.rb"
      symlinkTarget=$(printf '%s@%s%s.rb' "$fName" "$latestMajor" "$latestMinor")
      echo "  - Creating $symlinkName for $symlinkTarget"
      createSymlink "$symlinkTarget" "$symlinkName"
    else
      echo "  - Skipping $fName for latest => already exists"
    fi

    # Create all major of does not exist
    while read -r majorVersion; do
      echo "  - Processing major-version $majorVersion"

      latestMinor=$(yq -ot \
        '[.[] | select(.major == "'"$majorVersion"'") | .minor] | unique | sort | .[-1] // ""' \
        "$formulaVersionsFile")

      # Prepend dot if latest minor is not empty
      test -n "$latestMinor" && latestMinor=".$latestMinor"

      # Build symlink names and create it
      symlinkName=$(printf '%s@%s.rb' "$fName" "$majorVersion")
      symlinkTarget=$(printf '%s@%s%s.rb' "$fName" "$majorVersion" "$latestMinor")

      # Check if Formula exists, skip if so
      if [[ ! -f "Formula/$symlinkName" ]]; then
        echo "    - Creating $symlinkName for $symlinkTarget"
        createSymlink "$symlinkTarget" "$symlinkName"
      else
        echo "    - Skipping $symlinkName for $symlinkTarget => Formula exists"
      fi
    done < <(yq -e -ot -I0 '[.[] | .major] | unique | sort | .[]' <"$formulaVersionsFile")
done

aliasesCountAfter=$( (ls -1 Aliases/*.rb 2>/dev/null || true) | wc -l | tr -d ' ')
echo "Found $aliasesCountAfter aliases afterwards -- a change of $((aliasesCountAfter - aliasesCountBefore))"
