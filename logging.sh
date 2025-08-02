#!/bin/bash

# Setup logging
SCRIPT_DIR=$(dirname "$(realpath "$0")")
LOG_FILE="$SCRIPT_DIR/rewegain_install.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create log file first
touch "$LOG_FILE"

# Function to log messages
log_message() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

# Function to log errors
log_error() {
    echo "[$TIMESTAMP] ERROR: $1" | tee -a "$LOG_FILE" >&2
} 