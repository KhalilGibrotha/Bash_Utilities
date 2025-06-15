# Bash_Utilities

## root_cleaner.sh

`root_cleaner.sh` is a maintenance script used to clean up a Linux root filesystem. It remounts the root partition read/write if needed, checks and mounts `/var`, ensures swap space is configured and moves temporary or hidden files out of the root directory. The script binds the root filesystem to a temporary directory during cleanup and unmounts it when finished.

### Prerequisites

- Bash shell
- Root privileges (run with `sudo` or as the root user)

### Usage
Run the script from the repository directory with elevated privileges. The script prints progress messages to the console and may prompt for confirmation during filesystem checks.

### Example invocation

```bash
sudo bash root_cleaner.sh
```
