#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Ferdium installation..."

# Variables
log_message "Fetching latest Ferdium release information..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/ferdium/ferdium-app/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
log_message "Latest Ferdium version: $LATEST_VERSION"

DEB_URL="https://github.com/ferdium/ferdium-app/releases/download/$LATEST_VERSION/Ferdium-linux-${LATEST_VERSION#v}-amd64.deb"
DEB_FILE="$HOME/Downloads/programs/Ferdium-linux-${LATEST_VERSION#v}-amd64.deb"

# Create downloads/programs directory
log_message "Creating downloads directory: $HOME/Downloads/programs"
mkdir -p "$HOME/Downloads/programs" 2>&1 | tee -a "$LOG_FILE"

# Download Ferdium .deb package
log_message "Downloading Ferdium .deb package from: $DEB_URL"
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
log_message "Installing Ferdium .deb package..."
if sudo dpkg -i "$DEB_FILE" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Ferdium installed successfully"
else
    log_error "Ferdium installation failed"
    exit 1
fi

log_message "Ferdium installation completed successfully"
echo "Ferdium installed successfully! You can launch it from your applications menu." 