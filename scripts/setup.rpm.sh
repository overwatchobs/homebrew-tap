#!/bin/sh
# Adds the Overwatch dnf/yum repository (Buildkite Package Registries)
# to this system. Does NOT install overwatch-helper itself — run
# `sudo dnf install overwatch-helper` afterwards.
#
# Public registry — no auth tokens required.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/overwatchobs/overwatch/main/helper/packaging/install/setup.rpm.sh | sudo sh
#   sudo dnf install overwatch-helper
#
# Idempotent: re-running overwrites the .repo file with the same
# content — safe.
set -eu

ORG=overwatchobs
REGISTRY=overwatch-rpm
REPO_FILE=/etc/yum.repos.d/${ORG}-${REGISTRY}.repo

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root (try: sudo sh setup.rpm.sh)" >&2
    exit 1
fi

# Write the repository definition. baseurl uses Buildkite's rpm_any
# layout so a single repo serves x86_64, aarch64, etc. via $basearch.
# repo_gpgcheck=1 verifies the metadata signature (the registry signs
# repodata with the key at /gpgkey). gpgcheck=0 skips per-package
# signature checks — Buildkite signs at the repo level, not per RPM.
cat > "${REPO_FILE}" <<EOF
[${REGISTRY}]
name=Overwatch helper agent (rpm)
baseurl=https://packages.buildkite.com/${ORG}/${REGISTRY}/rpm_any/rpm_any/\$basearch
enabled=1
repo_gpgcheck=1
gpgcheck=0
gpgkey=https://packages.buildkite.com/${ORG}/${REGISTRY}/gpgkey
priority=1
EOF
chmod 644 "${REPO_FILE}"

echo "Overwatch dnf repository added."
echo "Now run: sudo dnf install overwatch-helper"
