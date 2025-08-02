#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Brave Browser installation..."

log_message "Running official Brave installation script..."
if curl -fsS https://dl.brave.com/install.sh | sh 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Brave Browser installation completed successfully"
else
    log_error "Brave Browser installation failed"
    exit 1
fi
