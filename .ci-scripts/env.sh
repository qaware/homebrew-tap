#!/usr/bin/env bash
set -euo pipefail

# Detect environment
if [[ -n "${GITLAB_CI:-}" ]]; then
  echo "Detected GitLab"
  runnerType="gitlab"
elif [[ -n "${GITHUB_REPOSITORY:-}" ]]; then
  echo "Detected GitHub"
  runnerType="github"
else
  echo "No runnerType/platform detected"
  exit 1
fi

export runnerType
