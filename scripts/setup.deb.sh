#!/bin/sh
# Adds the Overwatch apt repository (Buildkite Package Registries) to
# this system's apt sources, installs the GPG signing key, and runs
# `apt-get update`. Does NOT install overwatch-helper itself — run
# `sudo apt install overwatch-helper` afterwards.
#
# Public registry — no auth tokens required.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/overwatchobs/overwatch/main/helper/packaging/install/setup.deb.sh | sudo sh
#   sudo apt install overwatch-helper
#
# Idempotent: re-running does not break existing sources.
set -eu

ORG=overwatchobs
REGISTRY=overwatch-deb
KEYRING=/etc/apt/keyrings/${ORG}_${REGISTRY}-archive-keyring.gpg
SOURCE=/etc/apt/sources.list.d/${ORG}-${REGISTRY}.list

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root (try: sudo sh setup.deb.sh)" >&2
    exit 1
fi

# Dependencies for fetching + dearmoring the key.
apt-get update -qq
apt-get install -y --no-install-recommends curl gpg ca-certificates

# Install the registry's signing key.
mkdir -p /etc/apt/keyrings
curl -fsSL "https://packages.buildkite.com/${ORG}/${REGISTRY}/gpgkey" \
    | gpg --dearmor --yes -o "${KEYRING}"
chmod 644 "${KEYRING}"

# Add the source list.
cat > "${SOURCE}" <<EOF
deb [signed-by=${KEYRING}] https://packages.buildkite.com/${ORG}/${REGISTRY}/any/ any main
EOF
chmod 644 "${SOURCE}"

# Refresh apt's package index so the next `apt install` finds the
# new source.
apt-get update -qq

echo "Overwatch apt repository added."
echo "Now run: sudo apt install overwatch-helper"
