#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Discord installation..."

# Variables
DEB_URL="https://discord.com/api/download?platform=linux"
DEB_FILE="$HOME/Downloads/programs/discord_latest_amd64.deb"

# Create downloads/programs directory
log_message "Creating downloads directory: $HOME/Downloads/programs"
mkdir -p "$HOME/Downloads/programs" 2>&1 | tee -a "$LOG_FILE"

# Download Discord .deb package
log_message "Downloading Discord .deb package from: $DEB_URL"
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
log_message "Installing Discord .deb package..."
if sudo dpkg -i "$DEB_FILE" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Discord installed successfully"
else
    log_error "Discord installation failed"
    exit 1
fi

log_message "Discord installation completed successfully"
echo "Discord installed successfully! You can launch it from your applications menu." 