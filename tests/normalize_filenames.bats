#!/usr/bin/env bats

setup() {
  tmpdir="$BATS_TEST_DIRNAME/tmp"
  mkdir -p "$tmpdir/work/sub"
  cp "$BATS_TEST_DIRNAME/../normalize_filenames.sh" "$tmpdir/"
  cd "$tmpdir/work"
  touch "EvilAngel.23.03.29.Hazel.Moore.XXX.1080p.MP4-WRB"
  touch "sub/Inserted.24.07.18.Ruby.Moon.XXX.1080p.MP4-NBQ"
}

teardown() {
  rm -rf "$tmpdir"
}

@test "normalize filenames" {
  run bash "$tmpdir/normalize_filenames.sh" "$tmpdir/work"
  [ "$status" -eq 0 ]
  [ -f "EvilAngel 23.03.29 Hazel Moore 1080p.mp4" ]
  [ -f "Inserted 24.07.18 Ruby Moon 1080p.mp4" ]
}
