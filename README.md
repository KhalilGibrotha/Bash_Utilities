# Bash_Utilities

This repository contains small bash scripts.

## normalize_filenames.sh

Recursively scan a directory for video files that follow the pattern
`Title.YY.MM.DD.Subtitle.XXX.Resolution.Extension-GROUP` and rename them
into a cleaner format:

```
Title YY.MM.DD Subtitle Resolution.extension
```

Files that do not match the pattern are left untouched. Matching files are
moved to the current working directory.

Usage:

```bash
./normalize_filenames.sh [directory]
```

When `directory` is omitted, the current directory is used.
