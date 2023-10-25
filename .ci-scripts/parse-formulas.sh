#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

TAP_GEN_TMP_PATH=".parsed-formula"

if [[ -d "$TAP_GEN_TMP_PATH" ]]; then
    echo "$TAP_GEN_TMP_PATH already exists, deleting!"
    rm -rf "$TAP_GEN_TMP_PATH"
fi

mkdir "$TAP_GEN_TMP_PATH"

echo "Sort Formula:"
while read -r formulaFile; do
    formulaFile=$(basename "$formulaFile")

    if [[ "$formulaFile" =~ ^\. ]]; then
        echo -e "- $formulaFile\t| Skipping file as it starts with a dot"
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

    cat <<EOF >>"$TAP_GEN_TMP_PATH/$fName.yaml"
- major: '$fMajor'
  minor: '$fMinor'
  bugfix: '$fBugfix'
  buildtag: '$fBuildtag'
  filename: '$formulaFile'
EOF
done < <(find Formula -maxdepth 1 -type f -name '*.rb')

echo "Config files wrote to $TAP_GEN_TMP_PATH:"
(
    cd "$TAP_GEN_TMP_PATH"
    ls -a1 ./*.yaml || echo "No config files written..."
) || true
