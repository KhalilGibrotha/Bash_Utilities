# Bash_Utilities

This repository contains various utility scripts. Notable files:

- `root_cleaner.sh` – maintenance script used in testing.
- `create_offline_bundle.sh` – generate an offline Conda environment bundle for RHEL 9 servers.
- `deploy_offline_env.sh` – install the packaged environment system wide (default `/opt/data_analytics_env`).
- `setup_dev_profile.sh` – helper for developers to add an activation function to their shell profile.

## Offline environment workflow
1. Run `create_offline_bundle.sh` on a connected build machine. It asks for the Python version and output directory, creates `environment.yml`, builds the Conda environment, and packages it using `conda-pack`.
2. Transfer the resulting `RHEL9_Data_Analytics_Offline_Env_Bundle` directory to the air‑gapped server.
3. On the RHEL 9 server run `deploy_offline_env.sh` as root, pointing it to the `.tar.gz` archive inside the transferred folder. The environment is extracted to `/opt/data_analytics_env` and made executable for all users.
4. Each user executes `setup_dev_profile.sh` to add an `activate_da_env` helper to their `~/.bashrc` (or `~/.zshrc`). After sourcing the profile they can activate the environment and use tools like Jupyter Lab.
