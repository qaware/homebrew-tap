#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

tmpDir="/tmp/parsed-formula"

if [[ -d "$tmpDir" ]]; then
    echo "$tmpDir already exists, deleting! => Should happen only locally..."
    rm -rf "$tmpDir"
fi

mkdir "$tmpDir"

echo "Sort Formula:"
for formulaFile in $(ls -la1 Formula); do
    if [[ "$formulaFile" =~ ^\. ]]; then
        echo -e "- $formulaFile\t| Skipping file as it starts with a dot"
        continue
    elif [[ ! "$formulaFile" =~ .+\.rb$ ]]; then
        echo -e "- $formulaFile\t| Skipping as files does not end with .rb"
        continue
    fi
    
    # Remove .rb suffix
    formula=${formulaFile%.rb}
    
    if [[ ! "$formula" =~ ^[a-z0-9-]{2,}@([0-9]+)(\.[0-9]+)?(\.[0-9]+)?(-.+)?$ ]]; then
        # https://regex101.com/r/DSC7cM/1
        echo -e "- $formula\t| Skipping Formula as it doesn't seem to versioned"
        continue
    fi
    echo -e "- $formula\t| Processing..."
    fName=$(sed -rn 's/^([a-z0-9-]{2,})@([0-9]+)(\.([0-9]+))?(\.([0-9]+))?(-.+)?$/\1/p' <<<"$formula")
    fMajor=$(sed -rn 's/^([a-z0-9-]{2,})@([0-9]+)(\.([0-9]+))?(\.([0-9]+))?(-.+)?$/\2/p' <<<"$formula")
    fMinor=$(sed -rn 's/^([a-z0-9-]{2,})@([0-9]+)(\.([0-9]+))?(\.([0-9]+))?(-.+)?$/\4/p' <<<"$formula")
    fBugfix=$(sed -rn 's/^([a-z0-9-]{2,})@([0-9]+)(\.([0-9]+))?(\.([0-9]+))?(-.+)?$/\6/p' <<<"$formula")
    fBuildtag=$(sed -rn 's/^([a-z0-9-]{2,})@([0-9]+)(\.([0-9]+))?(\.([0-9]+))?(-.+)?$/\7/p' <<<"$formula")

    echo -e "- $formula\t| Found values: '$fName' '$fMajor' '$fMinor' '$fBugfix' '$fBuildtag'"

    cat <<EOF >> "$tmpDir/$fName.yaml"
- major: '$fMajor'
  minor: '$fMinor'
  bugfix: '$fBugfix'
  builtag: '$fBuildtag'
EOF
done

echo "Config files wrote to $tmpDir:"
(
    cd "$tmpDir"
    ls -la1 *.yaml
) || true