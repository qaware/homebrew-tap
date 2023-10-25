#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

aptGetInstallPackages=(wget)

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

# Install needed packages
echo "Installing packages with apt: ${aptGetInstallPackages[*]}"
# Install apt requirements
if [[ "$runnerType" == "gitlab" ]]; then
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update
  apt-get -qy install "${aptGetInstallPackages[*]}"
elif [[ "$runnerType" == "github" ]]; then
  echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
  sudo apt-get -q update
  sudo apt-get -qy install "${aptGetInstallPackages[*]}"
fi

# Install yq
# https://github.com/marketplace/actions/yq-portable-yaml-processor
echo "Installing yq"
wget -q -O yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x yq
test "$runnerType" = "gitlab" && mv yq /usr/bin/yq
test "$runnerType" = "github" && sudo mv yq /usr/bin/yq
