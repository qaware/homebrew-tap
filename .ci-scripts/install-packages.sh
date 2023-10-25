#!/usr/bin/env bash
set -euo pipefail

# Enable debug - print commands
#set -x

# Install yq
# https://github.com/marketplace/actions/yq-portable-yaml-processor
wget -q -O yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod +x yq
sudo mv yq /usr/bin/yq

