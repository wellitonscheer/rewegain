#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Kdenlive installation..."

log_message "Installing Kdenlive..."
sudo apt install kdenlive -y 2>&1 | tee -a "$LOG_FILE"

log_message "Kdenlive installation completed successfully"