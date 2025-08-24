#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting VLC installation..."

# Check if snap is available
if ! command -v snap &> /dev/null; then
    log_error "snap is required but not installed"
    exit 1
fi

# Install VLC via snap
log_message "Installing VLC via snap..."
if sudo snap install vlc 2>&1 | tee -a "$LOG_FILE"; then
    log_message "VLC installed successfully via snap"
else
    log_error "VLC installation failed"
    exit 1
fi

# Verify installation
log_message "Verifying VLC installation..."
if snap list | grep -q vlc 2>&1 | tee -a "$LOG_FILE"; then
    VLC_VERSION=$(snap list vlc | grep vlc | awk '{print $3}')
    log_message "VLC installed successfully: version $VLC_VERSION"
else
    log_error "VLC installation verification failed"
    exit 1
fi

log_message "VLC installation completed successfully" 