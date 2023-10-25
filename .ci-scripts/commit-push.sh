#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

git config --global user.name 'QAware Homebrew Bot'
git config --global user.email 'qaware.homebrew.bot@qaware.de'
git add Aliases README.md
git commit --quiet -m "chore: update Aliases" || {
  echo "Nothing to commit or commit failed, will exit now"
  exit 0
}
git push
