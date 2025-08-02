#!/bin/bash

# Use shared logging setup from main.sh
# LOG_FILE and logging functions are exported by main.sh

log_message "Starting Visual Studio Code installation..."

# Variables
DEB_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
DEB_FILE="$HOME/Downloads/programs/code_latest_amd64.deb"

# Create downloads/programs directory
log_message "Creating downloads directory: $HOME/Downloads/programs"
mkdir -p "$HOME/Downloads/programs" 2>&1 | tee -a "$LOG_FILE"

# Download Visual Studio Code .deb package
log_message "Downloading Visual Studio Code .deb package from: $DEB_URL"
if curl -L "$DEB_URL" -o "$DEB_FILE" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Download completed: $DEB_FILE"
else
    log_error "Download failed"
    exit 1
fi

# Check if download was successful
if [ ! -f "$DEB_FILE" ]; then
  log_error "Download failed. Please check the URL or your network connection."
  echo "Download failed. Please check the URL or your network connection."
  exit 1
fi

# Install the .deb package
log_message "Installing Visual Studio Code .deb package..."
if sudo dpkg -i "$DEB_FILE" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Visual Studio Code installed successfully"
else
    log_error "Visual Studio Code installation failed"
    exit 1
fi

log_message "Visual Studio Code installation completed successfully"
echo "Visual Studio Code installed successfully! You can launch it by typing 'code'."
