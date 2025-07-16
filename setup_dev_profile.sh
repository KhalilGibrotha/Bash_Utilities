#!/bin/bash
set -euo pipefail

# Script for developers to configure their shell for the system-wide environment

ENV_PATH="/opt/data_analytics_env"
RC_FILE="$HOME/.bashrc"

if [[ -n "${ZSH_VERSION-}" ]]; then
  RC_FILE="$HOME/.zshrc"
fi

ACT_FUNC="activate_da_env() {\n  source $ENV_PATH/bin/activate\n}"

grep -F "activate_da_env" "$RC_FILE" >/dev/null 2>&1 || {
  echo -e "\n# Data analytics environment" >> "$RC_FILE"
  echo -e "$ACT_FUNC" >> "$RC_FILE"
}

echo "Add the environment's bin directory to PATH when active."
echo "Run 'source $RC_FILE' then use 'activate_da_env' to start the environment."

echo "To run Jupyter Lab:"
echo "  activate_da_env && jupyter-lab --no-browser --port=8888"
echo "and from your local machine create an SSH tunnel:"
echo "  ssh -N -L 8888:localhost:8888 <user>@<rhel9_server>"
echo "Remember to set a Jupyter password or token for security."
