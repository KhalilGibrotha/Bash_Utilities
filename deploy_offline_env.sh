#!/bin/bash
set -euo pipefail

# Script to deploy the offline Conda environment system-wide on RHEL9

INSTALL_PATH="/opt/data_analytics_env"
read -rp "Path to conda-pack archive (.tar.gz): " ARCHIVE

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root to install to $INSTALL_PATH" >&2
  exit 1
fi

command -v tar >/dev/null || { echo "tar is required" >&2; exit 1; }
command -v gzip >/dev/null || { echo "gzip is required" >&2; exit 1; }

echo "Ensure required OS packages are installed via dnf (git, Python libs, GPU drivers if needed)."

mkdir -p "$INSTALL_PATH"

echo "Extracting environment..."
tar -xzf "$ARCHIVE" -C "$INSTALL_PATH"

if [[ -f "$INSTALL_PATH/conda-unpack" ]]; then
  "$INSTALL_PATH/conda-unpack"
fi

chmod -R a+rx "$INSTALL_PATH"

echo "Environment installed to $INSTALL_PATH"
