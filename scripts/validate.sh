#!/usr/bin/env bash

# Validate data/*.geojson against RFC 7946 via @mapbox/geojsonhint (npx, no
# install). geojsonhint exits non-zero only on real errors — winding warnings
# are advisory — so we trust its per-file exit code.

set -euo pipefail

# empty glob → no iterations, not the literal pattern
shopt -s nullglob

# run from repo root regardless of caller's cwd
cd "$(dirname "$0")/.."

count=0
failed=0
advisories=0

for f in data/*.geojson; do
  count=$((count + 1))

  # Quiet on success; print only files that fail (with the error detail).
  if out=$(npx --yes @mapbox/geojsonhint@3.3.0 "$f" 2>&1); then
    [ -n "$out" ] && advisories=$((advisories + 1)) # passed but had warnings
  else
    echo "::error file=$f::"
    printf '%s\n' "$out" | sed 's/^/    /'
    failed=1
  fi
done

if [ "$count" -eq 0 ]; then
  echo "::error::No .geojson files found under data/."
  exit 1
fi

if [ "$failed" -ne 0 ]; then
  echo "::error::One or more GeoJSON files failed validation."
  exit 1
fi

summary="All $count GeoJSON files are valid."
[ "$advisories" -gt 0 ] && summary="$summary ($advisories with non-fatal winding advisories)"
echo "$summary"
