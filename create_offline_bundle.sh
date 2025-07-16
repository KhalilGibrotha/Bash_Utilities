#!/bin/bash
set -euo pipefail

# Script to create an offline bundle of a Conda environment for RHEL9

read -rp "Enter desired Python version (e.g. 3.9 or 3.11): " PY_VER
read -rp "Enter output directory for bundle: " OUT_DIR

BUNDLE_DIR="${OUT_DIR%/}/RHEL9_Data_Analytics_Offline_Env_Bundle"
PKG_DIR="$BUNDLE_DIR/packaged_env"
ENV_FILE="$BUNDLE_DIR/environment.yml"
ENV_NAME="data_analytics_env"

mkdir -p "$PKG_DIR"

cat > "$ENV_FILE" <<EOT
name: $ENV_NAME
channels:
  - conda-forge
  - defaults
dependencies:
  - python=${PY_VER}
  - pandas
  - scikit-learn
  - matplotlib
  - scipy
  - tensorflow-cpu     # For GPU support, change to tensorflow-gpu and ensure NVIDIA CUDA Toolkit and cuDNN are installed at the OS level on RHEL 9. You may also need to add specific Conda channels like nvidia or conda-forge for GPU-enabled builds.
  - pytorch-cpu        # For GPU support, change to pytorch-cuda and ensure NVIDIA CUDA Toolkit and cuDNN are installed at the OS level on RHEL 9. You may also need to add specific Conda channels like pytorch for GPU-enabled builds.
  - seaborn
  - beautifulsoup4
  - jupyterlab
  - ipykernel
  - conda-pack
EOT

echo "Creating Conda environment..."
source "$(conda info --base)/etc/profile.d/conda.sh"
conda env remove -n "$ENV_NAME" >/dev/null 2>&1 || true
conda env create -n "$ENV_NAME" -f "$ENV_FILE"

echo "Packaging environment..."
conda activate "$ENV_NAME"
PACK_PATH="$PKG_DIR/${ENV_NAME}.tar.gz"
conda-pack -o "$PACK_PATH" --compress-level 9
conda deactivate

if [[ -f "$PACK_PATH" ]]; then
  echo "Environment packaged successfully at: $PACK_PATH"
  echo "Transfer the folder '$BUNDLE_DIR' to the target RHEL9 server."
else
  echo "Failed to create package" >&2
  exit 1
fi
