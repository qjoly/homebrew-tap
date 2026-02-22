#!/bin/bash
set -e

# Configuration
FORMULA_DIR="Formula"

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "Error: gh (GitHub CLI) is not installed."
    exit 1
fi

# Loop through all ruby files in the Formula directory
for formula_file in "$FORMULA_DIR"/*.rb; do
    if [ ! -f "$formula_file" ]; then
        continue
    fi

    echo "Processing $formula_file..."

    # Extract repository from homepage or url
    # Assumes format: homepage "https://github.com/OWNER/REPO"
    REPO_URL=$(grep -m 1 'homepage' "$formula_file" | cut -d'"' -f2)
    
    if [[ "$REPO_URL" != *"github.com"* ]]; then
        echo "  Skipping: Homepage is not a GitHub URL ($REPO_URL)"
        continue
    fi

    # Extract Owner/Repo from URL
    REPO=$(echo "$REPO_URL" | sed 's|https://github.com/||' | sed 's|/$||')
    echo "  Repository: $REPO"

    # Fetch latest release tag
    echo "  Fetching latest release tag..."
    LATEST_TAG=$(gh release view --repo "$REPO" --json tagName --jq .tagName || echo "")

    if [ -z "$LATEST_TAG" ]; then
        echo "  Error: Could not determine latest tag for $REPO"
        continue
    fi

    echo "  Latest tag: $LATEST_TAG"

    # Check if the formula is already up to date
    # We check if the file contains the latest tag in the url line
    if grep -q "refs/tags/$LATEST_TAG.tar.gz" "$formula_file"; then
        echo "  Formula is already up to date ($LATEST_TAG)."
        continue
    fi

    # Construct download URL
    # Using the standard archive format for GitHub releases
    URL="https://github.com/$REPO/archive/refs/tags/$LATEST_TAG.tar.gz"

    echo "  Downloading source to calculate SHA256..."
    TEMP_FILE=$(mktemp)
    if ! curl -L -s -o "$TEMP_FILE" "$URL"; then
        echo "  Error: Failed to download $URL"
        rm "$TEMP_FILE"
        continue
    fi

    echo "  Calculating SHA256..."
    # Calculate SHA256 (compatible with macOS and Linux)
    if command -v shasum &> /dev/null; then
        SHA256=$(shasum -a 256 "$TEMP_FILE" | awk '{print $1}')
    else
        SHA256=$(sha256sum "$TEMP_FILE" | awk '{print $1}')
    fi
    rm "$TEMP_FILE"

    echo "  New SHA256: $SHA256"

    # Update the formula file
    echo "  Updating $formula_file..."
    
    # Create a temporary file for the new content
    TMP_FORMULA=$(mktemp)
    
    # Use sed to update URL and SHA256
    # We match the url line and replace the whole line
    # We match the sha256 line and replace the whole line
    
    # Note: This simple sed assumes standard formatting. 
    # For robust Ruby parsing, a ruby script would be better, but sed works for simple formulas.
    
    # macOS requires strict empty string argument for -i, Linux does not allow it.
    # Using a temp file approach to be safer and cross-platform compatible without -i quirks.
    
    # 1. Update URL
    # This regex looks for 'url "..."' and replaces it with the new URL
    sed "s|url \".*\"|url \"$URL\"|" "$formula_file" > "$TMP_FORMULA"
    
    # 2. Update SHA256
    # This regex looks for 'sha256 "..."' and replaces it with the new SHA256
    sed "s|sha256 \".*\"|sha256 \"$SHA256\"|" "$TMP_FORMULA" > "$formula_file" # Overwrite original
    
    rm "$TMP_FORMULA"
    
    echo "  Successfully updated $formula_file to $LATEST_TAG"
done

echo "Done."
