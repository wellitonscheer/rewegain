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

# Export logging variables and functions for other scripts
export LOG_FILE
export TIMESTAMP
export -f log_message
export -f log_error

# Initialize log file
log_message "=== Starting Rewegain Installation ==="
log_message "Log file: $LOG_FILE"

# Check if email is passed as a parameter
if [ -z "$1" ]; then
  log_error "No email provided."
  echo "Error: No email provided."
  echo "Usage: $0 your_email@example.com"
  exit 1
fi

# Use the provided email from the first parameter
export EMAIL="$1"
export HOST_NAME="caie-pc"
log_message "Email: $EMAIL"
log_message "Host name: $HOST_NAME"

# Update system
log_message "Updating system packages..."
sudo apt update 2>&1 | tee -a "$LOG_FILE"

# Install dependencies
log_message "Installing curl..."
sudo apt install curl -y 2>&1 | tee -a "$LOG_FILE"

log_message "Adding universe repository..."
sudo add-apt-repository universe -y 2>&1 | tee -a "$LOG_FILE"

log_message "Installing libfuse2t64..."
sudo apt install libfuse2t64 -y 2>&1 | tee -a "$LOG_FILE"

SHELL_CONFIG="$HOME/.bashrc"
log_message "Script directory: $SCRIPT_DIR"

# Find all .sh files in the directory, excluding main.sh itself
SH_FILES=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.sh" ! -name "main.sh")

# Give execute permission to all .sh files
log_message "Setting execute permissions for all .sh files..."
for FILE in $SH_FILES; do
    chmod +x "$FILE"
    log_message "Permissions set for: $FILE"
done

# Run all .sh files
log_message "Running all .sh files..."
for FILE in $SH_FILES; do
    log_message "Running $FILE..."
    if "$FILE" 2>&1 | tee -a "$LOG_FILE"; then
        log_message "Successfully completed: $FILE"
    else
        log_error "Failed to complete: $FILE"
    fi
done

# Fix missing dependencies
log_message "Fixing dependencies..."
sudo apt-get install -f -y 2>&1 | tee -a "$LOG_FILE"

log_message "Final system update..."
sudo apt update 2>&1 | tee -a "$LOG_FILE"
sudo apt upgrade -y 2>&1 | tee -a "$LOG_FILE"

# Reload shell config
source "$SHELL_CONFIG"

log_message "=== Installation completed ==="
log_message "Check the log file for details: $LOG_FILE"
echo "All scripts have been executed successfully!"
echo "Log file: $LOG_FILE"
