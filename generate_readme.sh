#!/usr/bin/env bash
# generate_readme.sh — regenerate README.md from all Formula/*.rb files
set -euo pipefail

FORMULA_DIR="Formula"
OUT="README.md"

# ── helpers ──────────────────────────────────────────────────────────────────

ruby_field() {
  # Extract a single-quoted or double-quoted field from a .rb file
  # Usage: ruby_field <file> <field>  → prints the value or ""
  local file="$1" field="$2"
  grep -m1 "^  ${field} " "$file" 2>/dev/null \
    | sed "s/^  ${field} ['\"]//;s/['\"]$//" \
    || true
}

latest_version() {
  # Get the latest GitHub release tag for a repo (Owner/Repo)
  local repo="$1"
  gh release view --repo "$repo" --json tagName --jq '.tagName' 2>/dev/null || echo ""
}

# ── collect formula data ──────────────────────────────────────────────────────

declare -a NAMES DESCS HOMEPAGES VERSIONS INSTALLS

for rb in "$FORMULA_DIR"/*.rb; do
  [ -f "$rb" ] || continue

  # Formula name from filename (talosctl-oidc.rb → talosctl-oidc)
  name=$(basename "$rb" .rb)

  desc=$(ruby_field "$rb" "desc")
  homepage=$(ruby_field "$rb" "homepage")

  # Version: prefer latest GitHub release if homepage is on GitHub
  version=""
  if [[ "$homepage" == *"github.com"* ]]; then
    repo=$(echo "$homepage" | sed 's|https://github.com/||;s|/$||')
    version=$(latest_version "$repo")
  fi
  # Fallback: version field in formula
  if [[ -z "$version" ]]; then
    version=$(ruby_field "$rb" "version")
  fi
  [[ -z "$version" ]] && version="—"

  NAMES+=("$name")
  DESCS+=("$desc")
  HOMEPAGES+=("$homepage")
  VERSIONS+=("$version")
  INSTALLS+=("brew install qjoly/tap/${name}")
done

# ── render README ─────────────────────────────────────────────────────────────

cat > "$OUT" << 'HEADER'
# homebrew-tap

Homebrew tap for qjoly's tools.

## How to use

```bash
brew tap qjoly/tap
```

## Available Formulae

HEADER

# Table header
printf "| Formula | Description | Version | Install |\n" >> "$OUT"
printf "| --- | --- | --- | --- |\n" >> "$OUT"

for i in "${!NAMES[@]}"; do
  name="${NAMES[$i]}"
  desc="${DESCS[$i]}"
  homepage="${HOMEPAGES[$i]}"
  version="${VERSIONS[$i]}"
  install="${INSTALLS[$i]}"

  if [[ -n "$homepage" ]]; then
    name_cell="[\`${name}\`](${homepage})"
  else
    name_cell="\`${name}\`"
  fi

  printf "| %s | %s | %s | \`%s\` |\n" \
    "$name_cell" "$desc" "$version" "$install" >> "$OUT"
done

cat >> "$OUT" << 'FOOTER'

## Updating

Formulae are updated automatically every day via GitHub Actions.
To trigger a manual update: **Actions → Update formulae & README → Run workflow**.
FOOTER

echo "README regenerated → $OUT"
