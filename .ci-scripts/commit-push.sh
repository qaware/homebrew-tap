#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# shellcheck source-path=.ci-scripts
source "$SCRIPT_PATH/env.sh"

git add Aliases README.md
git commit --quiet -m "chore: update Aliases" || {
  echo "Nothing to commit or commit failed, will exit now"
  exit 0
}

if [[ "$runnerType" == "gitlab" ]]; then
  git push "https://oauth2:${REPO_WRITE_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git" "HEAD:$CI_COMMIT_BRANCH"
elif [[ "$runnerType" == "github" ]]; then
  git push
fi
