#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

git add README.md
git commit --quiet -m "chore: update TOC" || {
  echo "Nothing to commit or commit failed, will exit now"
  exit 0
}
git push
