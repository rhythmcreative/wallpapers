#!/bin/bash

# Target directory
WALL_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALL_DIR"

# Check if a specific pack was requested
SPECIFIC_PACK=$1

extract_pack() {
    local zip=$1
    if [ -f "$zip" ]; then
        echo "Extracting $zip..."
        unzip -q -o "$zip" -d "/tmp/wallpaper_extract"
        pack_dir="/tmp/wallpaper_extract/${zip%.zip}"
        if [ -d "$pack_dir" ]; then
            cp -r "$pack_dir"/* "$WALL_DIR/"
            rm -rf "$pack_dir"
        fi
    else
        echo "Error: $zip not found."
    fi
}

if [ -z "$SPECIFIC_PACK" ]; then
    echo "Extracting all wallpaper packs to $WALL_DIR..."
    for zip in pack_*.zip; do
        extract_pack "$zip"
    done
    echo "Done! All wallpapers extracted to $WALL_DIR."
else
    # Normalize input (e.g., if user inputs "1" instead of "pack_1.zip")
    if [[ "$SPECIFIC_PACK" =~ ^[0-9]+$ ]]; then
        zip="pack_${SPECIFIC_PACK}.zip"
    elif [[ "$SPECIFIC_PACK" == pack_* ]]; then
        zip="${SPECIFIC_PACK}.zip"
    else
        zip="$SPECIFIC_PACK"
    fi
    
    extract_pack "$zip"
    echo "Done! $zip extracted to $WALL_DIR."
fi

rm -rf "/tmp/wallpaper_extract"
