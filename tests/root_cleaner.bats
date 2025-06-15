#!/usr/bin/env bats

@test "swap space check message" {
  tmpdir="$BATS_TEST_DIRNAME/tmp"
  mkdir -p "$tmpdir/stubs"
  PATH="$tmpdir/stubs:$PATH"

  # stub grep to pretend /var is already mounted
  cat >"$tmpdir/stubs/grep" <<'GEOF'
#!/usr/bin/env bash
if [[ "$1" == "/dev/mapper/AtmosVG-LVvar" && "$2" == "/proc/mounts" ]]; then
  echo "/dev/mapper/AtmosVG-LVvar /var xfs rw 0 0"
else
  /bin/grep "$@"
fi
GEOF
  chmod +x "$tmpdir/stubs/grep"

  cat >"$tmpdir/stubs/swapon" <<'GEOF'
#!/usr/bin/env bash
if [[ "$1" == "-s" ]]; then
  exit 0
else
  echo "swapon stub $@" > /dev/null
fi
GEOF
  chmod +x "$tmpdir/stubs/swapon"

  cat >"$tmpdir/stubs/mkswap" <<'GEOF'
#!/usr/bin/env bash
echo "mkswap stub $@" > /dev/null
GEOF
  chmod +x "$tmpdir/stubs/mkswap"

  cat >"$tmpdir/stubs/free" <<'GEOF'
#!/usr/bin/env bash
echo "             total       used       free"
echo "Swap:            0          0          0"
GEOF
  chmod +x "$tmpdir/stubs/free"

  cat >"$tmpdir/stubs/mkdir" <<'GEOF'
#!/usr/bin/env bash
exit 1
GEOF
  chmod +x "$tmpdir/stubs/mkdir"

  run bash "$BATS_TEST_DIRNAME/../root_cleaner.sh"
  [[ "${lines[*]}" == *"Checking if swap space is  configured:"* ]]
  [[ "${lines[*]}" == *"No swap space detected!"* ]]
}
