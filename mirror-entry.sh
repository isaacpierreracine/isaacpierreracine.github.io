#!/bin/bash
# mirror-entry.sh — mirrors a French entry into English and Spanish
# Usage: bash mirror-entry.sh content/art/autour-du-moulin/le-projet

SITE="$HOME/Documents/hugo/stack"

if [ -z "$1" ]; then
    echo "Usage: bash mirror-entry.sh <path-relative-to-site-root>"
    echo "Example: bash mirror-entry.sh content/art/autour-du-moulin/le-projet"
    exit 1
fi

FR_REL="$1"
FR_FULL="$SITE/$FR_REL"

if [ ! -d "$FR_FULL" ]; then
    echo "Error: folder not found at $FR_FULL"
    exit 1
fi

if [ ! -f "$FR_FULL/index.md" ]; then
    echo "Error: no index.md found in $FR_FULL"
    exit 1
fi

# Build EN and ES paths by inserting /en/ and /es/ after /content/
AFTER_CONTENT="${FR_REL#content/}"
EN_FULL="$SITE/content/en/$AFTER_CONTENT"
ES_FULL="$SITE/content/es/$AFTER_CONTENT"

echo "→ Source:  $FR_FULL"
echo "→ English: $EN_FULL"
echo "→ Spanish: $ES_FULL"
echo ""

mkdir -p "$EN_FULL"
mkdir -p "$ES_FULL"

# Copy images
COPIED=0
for ext in jpg jpeg png webp gif; do
    for img in "$FR_FULL"/*.$ext; do
        if [ -f "$img" ]; then
            cp "$img" "$EN_FULL/"
            cp "$img" "$ES_FULL/"
            echo "  copied: $(basename $img)"
            COPIED=$((COPIED + 1))
        fi
    done
done

if [ "$COPIED" -eq 0 ]; then
    echo "  no images found"
fi

# Create placeholder index.md files
cat > "$EN_FULL/index.md" << PLACEHOLDER
<!-- TO TRANSLATE — replace this entire file with the English translation -->
$(cat "$FR_FULL/index.md")
PLACEHOLDER

cat > "$ES_FULL/index.md" << PLACEHOLDER
<!-- TO TRANSLATE — replace this entire file with the Spanish translation -->
$(cat "$FR_FULL/index.md")
PLACEHOLDER

echo ""
echo "✓ Done."
echo ""
echo "Next: paste translations into:"
echo "  $EN_FULL/index.md"
echo "  $ES_FULL/index.md"
