#!/bin/bash

APP_DIR="$HOME/Applications"
ALIAS_NAME="bit"
APPIMAGE_URL="https://bitwarden.com/download/?app=desktop&platform=linux&variant=appimage"
SHELL_CONFIG="$HOME/.bashrc"

mkdir -p "$APP_DIR"

# Download the AppImage using original filename (follow redirects)
echo "Downloading Bitwarden AppImage..."
cd "$APP_DIR" || exit 1
curl -LOJ "$APPIMAGE_URL"

# Find the downloaded AppImage using pattern
APPIMAGE_PATH=$(find "$APP_DIR" -type f -name 'Bitwarden*.AppImage' | head -n 1)

if [ -z "$APPIMAGE_PATH" ]; then
    echo "Download failed or file not found."
    exit 1
fi

# Make it executable
chmod +x "$APPIMAGE_PATH"
echo "Made AppImage executable: $APPIMAGE_PATH"

# Add alias using pattern matching
ALIAS_LINE="alias $ALIAS_NAME=\"\$(find $APP_DIR -type f -name 'Bitwarden*.AppImage' | head -n 1) --no-sandbox &\""

# Add alias if not already present
if ! grep -Fq "$ALIAS_LINE" "$SHELL_CONFIG"; then
    echo "$ALIAS_LINE" >> "$SHELL_CONFIG"
    echo "Alias '$ALIAS_NAME' added to $SHELL_CONFIG"
else
    echo "Alias '$ALIAS_NAME' already exists in $SHELL_CONFIG"
fi

# Reload shell config
source "$SHELL_CONFIG"

echo "Done! You can now run Bitwarden by typing '$ALIAS_NAME'"
