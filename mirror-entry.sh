#!/bin/bash
# mirror-entry.sh — mirrors a French entry into English and Spanish
# Usage: bash mirror-entry.sh content/fr/art/autour-du-moulin/echeancier

SITE="$HOME/Documents/hugo/stack"

if [ -z "$1" ]; then
    echo "Usage: bash mirror-entry.sh <path-relative-to-site-root>"
    echo "Example: bash mirror-entry.sh content/fr/art/autour-du-moulin/le-projet"
    exit 1
fi

FR_REL="$1"
FR_FULL="$SITE/$FR_REL"

if [ ! -d "$FR_FULL" ]; then
    echo "Error: folder not found at $FR_FULL"
    exit 1
fi

if [ ! -f "$FR_FULL/index.md" ] && [ ! -f "$FR_FULL/_index.md" ]; then
    echo "Error: no index.md or _index.md found in $FR_FULL"
    exit 1
fi

AFTER_CONTENT="${FR_REL#content/}"
AFTER_CONTENT="${AFTER_CONTENT#fr/}"
AFTER_CONTENT="${AFTER_CONTENT#en/}"
AFTER_CONTENT="${AFTER_CONTENT#es/}"

EN_FULL="$SITE/content/en/$AFTER_CONTENT"
ES_FULL="$SITE/content/es/$AFTER_CONTENT"

echo "→ Source:  $FR_FULL"
echo "→ English: $EN_FULL"
echo "→ Spanish: $ES_FULL"
echo ""

mkdir -p "$EN_FULL"
mkdir -p "$ES_FULL"

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

if [ -f "$FR_FULL/index.md" ]; then
    SRC_FILE="$FR_FULL/index.md"
    DST_FILE="index.md"
else
    SRC_FILE="$FR_FULL/_index.md"
    DST_FILE="_index.md"
fi

FR_CONTENT=$(cat "$SRC_FILE")

printf '%s\n%s\n' "<!-- TO TRANSLATE — replace this entire file with the English translation -->" "$FR_CONTENT" > "$EN_FULL/$DST_FILE"
printf '%s\n%s\n' "<!-- TO TRANSLATE — replace this entire file with the Spanish translation -->" "$FR_CONTENT" > "$ES_FULL/$DST_FILE"

echo ""
echo "✓ Done."
echo ""
echo "Next: paste translations into:"
echo "  $EN_FULL/$DST_FILE"
echo "  $ES_FULL/$DST_FILE"
