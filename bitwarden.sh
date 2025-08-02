#!/bin/bash

# Use shared logging setup from main.sh
# LOG_FILE and logging functions are exported by main.sh

log_message "Starting Bitwarden installation..."

APP_DIR="$HOME/Applications"
ALIAS_NAME="bit"
APPIMAGE_URL="https://bitwarden.com/download/?app=desktop&platform=linux&variant=appimage"
SHELL_CONFIG="$HOME/.bashrc"

# Create Applications directory
log_message "Creating Applications directory: $APP_DIR"
mkdir -p "$APP_DIR" 2>&1 | tee -a "$LOG_FILE"

# Download the AppImage using original filename (follow redirects)
log_message "Downloading Bitwarden AppImage from: $APPIMAGE_URL"
cd "$APP_DIR" || {
    log_error "Failed to change to Applications directory"
    exit 1
}

curl -LOJ "$APPIMAGE_URL" 2>&1 | tee -a "$LOG_FILE"

# Find the downloaded AppImage using pattern
APPIMAGE_PATH=$(find "$APP_DIR" -type f -name 'Bitwarden*.AppImage' | head -n 1)

if [ -z "$APPIMAGE_PATH" ]; then
    log_error "Download failed or file not found"
    exit 1
fi

log_message "AppImage downloaded: $APPIMAGE_PATH"

# Make it executable
chmod +x "$APPIMAGE_PATH" 2>&1 | tee -a "$LOG_FILE"
log_message "Made AppImage executable: $APPIMAGE_PATH"

# Add alias using pattern matching
ALIAS_LINE="alias $ALIAS_NAME=\"\$(find $APP_DIR -type f -name 'Bitwarden*.AppImage' | head -n 1) --no-sandbox &\""

# Add alias if not already present
if ! grep -Fq "$ALIAS_LINE" "$SHELL_CONFIG"; then
    echo "$ALIAS_LINE" >> "$SHELL_CONFIG" 2>&1 | tee -a "$LOG_FILE"
    log_message "Alias '$ALIAS_NAME' added to $SHELL_CONFIG"
else
    log_message "Alias '$ALIAS_NAME' already exists in $SHELL_CONFIG"
fi

# Reload shell config
source "$SHELL_CONFIG" 2>&1 | tee -a "$LOG_FILE"

log_message "Bitwarden installation completed successfully"
echo "Done! You can now run Bitwarden by typing '$ALIAS_NAME'"
