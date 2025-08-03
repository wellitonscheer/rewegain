#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Miniconda installation..."

# Check if wget is available
if ! command -v wget &> /dev/null; then
    log_error "wget is required but not installed"
    exit 1
fi

# Check if bash is available
if ! command -v bash &> /dev/null; then
    log_error "bash is required but not installed"
    exit 1
fi

# Download Miniconda installer
log_message "Downloading Miniconda installer..."
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_INSTALLER="$HOME/Miniconda3-latest-Linux-x86_64.sh"

if wget "$MINICONDA_URL" -O "$MINICONDA_INSTALLER" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Miniconda installer downloaded successfully"
else
    log_error "Failed to download Miniconda installer"
    exit 1
fi

# Make installer executable
log_message "Making installer executable..."
if chmod +x "$MINICONDA_INSTALLER" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Installer made executable"
else
    log_error "Failed to make installer executable"
    exit 1
fi

# Run Miniconda installer
log_message "Running Miniconda installer..."
log_message "Note: The installer will prompt for user input. Please follow the prompts."
if bash "$MINICONDA_INSTALLER" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Miniconda installer completed successfully"
else
    log_error "Miniconda installation failed"
    exit 1
fi

# Clean up installer file
log_message "Cleaning up installer file..."
if rm "$MINICONDA_INSTALLER" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Installer file removed"
else
    log_message "Warning: Failed to remove installer file"
fi

log_message "Miniconda installation completed successfully" 