#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# shellcheck source-path=.ci-scripts
source "$SCRIPT_PATH/env.sh"

aptGetInstallPackages=(git wget)

# Install needed packages
echo "Installing ${#aptGetInstallPackages[*]} packages with apt: ${aptGetInstallPackages[*]}"
# Install apt requirements
if [[ "$runnerType" == "gitlab" ]]; then
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update
  apt-get -qy install "${aptGetInstallPackages[@]}"
elif [[ "$runnerType" == "github" ]]; then
  echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
  sudo apt-get -q update
  sudo apt-get -qy install "${aptGetInstallPackages[@]}"
fi

# Install yq
# https://github.com/marketplace/actions/yq-portable-yaml-processor
echo "Installing yq"
wget -q -O yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x yq
if [[ "$runnerType" == "gitlab" ]]; then
  mv yq /usr/bin/yq
elif [[ "$runnerType" == "github" ]]; then
  sudo mv yq /usr/bin/yq
fi
