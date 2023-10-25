#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

git add Aliases README.md
git commit --quiet -m "chore: update Aliases" || {
  echo "Nothing to commit or commit failed, will exit now"
  exit 0
}
git push "https://oauth2:${REPO_WRITE_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git" "HEAD:$CI_COMMIT_BRANCH"
