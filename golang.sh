#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Go installation..."

# Check if required dependencies are available
if ! command -v wget &> /dev/null; then
    log_error "wget is required but not installed"
    exit 1
fi

if ! command -v tar &> /dev/null; then
    log_error "tar is required but not installed"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    log_error "curl is required but not installed"
    exit 1
fi

# Fetch latest Go version from official download page
log_message "Fetching latest Go version information..."
LATEST_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1)

if [ -z "$LATEST_VERSION" ]; then
    log_error "Failed to fetch latest Go version, falling back to known stable version"
    LATEST_VERSION="go1.25.3"
fi

# Remove 'go' prefix if present for version number
GO_VERSION="${LATEST_VERSION#go}"
log_message "Latest Go version: ${LATEST_VERSION} (${GO_VERSION})"

# Set architecture and construct download URL
GO_ARCH="linux-amd64"
GO_TARBALL="${LATEST_VERSION}.${GO_ARCH}.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"
DOWNLOAD_PATH="/tmp/${GO_TARBALL}"

log_message "Download URL: ${GO_URL}"

# Download Go tarball
log_message "Downloading Go ${GO_VERSION} from ${GO_URL}..."
if wget "$GO_URL" -O "$DOWNLOAD_PATH" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Go tarball downloaded successfully to ${DOWNLOAD_PATH}"
else
    log_error "Failed to download Go tarball"
    exit 1
fi

# Remove any previous Go installation
log_message "Removing any previous Go installation..."
if sudo rm -rf /usr/local/go 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Previous Go installation removed (if it existed)"
else
    log_error "Failed to remove previous Go installation"
    exit 1
fi

# Extract Go tarball to /usr/local
log_message "Extracting Go tarball to /usr/local..."
if sudo tar -C /usr/local -xzf "$DOWNLOAD_PATH" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Go extracted successfully to /usr/local/go"
else
    log_error "Failed to extract Go tarball"
    exit 1
fi

# Clean up downloaded tarball
log_message "Cleaning up downloaded tarball..."
if rm "$DOWNLOAD_PATH" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Tarball removed from ${DOWNLOAD_PATH}"
else
    log_message "Warning: Failed to remove tarball from ${DOWNLOAD_PATH}"
fi

# Add Go to PATH in .profile if not already present
PROFILE_FILE="$HOME/.profile"
GO_PATH_EXPORT='export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin'

log_message "Checking if Go is already in PATH..."
if grep -q "/usr/local/go/bin" "$PROFILE_FILE" 2>/dev/null; then
    log_message "Go is already in PATH in ${PROFILE_FILE}"
else
    log_message "Adding Go to PATH in ${PROFILE_FILE}..."
    echo "" >> "$PROFILE_FILE"
    echo "# Go installation" >> "$PROFILE_FILE"
    echo "$GO_PATH_EXPORT" >> "$PROFILE_FILE"
    log_message "Go added to PATH in ${PROFILE_FILE}"
fi

# Also add to shell config for immediate availability
SHELL_CONFIG="${SHELL_CONFIG:-$HOME/.bashrc}"
if grep -q "/usr/local/go/bin" "$SHELL_CONFIG" 2>/dev/null; then
    log_message "Go is already in PATH in ${SHELL_CONFIG}"
else
    log_message "Adding Go to PATH in ${SHELL_CONFIG}..."
    echo "" >> "$SHELL_CONFIG"
    echo "# Go installation" >> "$SHELL_CONFIG"
    echo "$GO_PATH_EXPORT" >> "$SHELL_CONFIG"
    log_message "Go added to PATH in ${SHELL_CONFIG}"
fi

# Verify installation
log_message "Verifying Go installation..."
if /usr/local/go/bin/go version 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Go installation verified successfully"
else
    log_error "Go installation verification failed"
    exit 1
fi

log_message "Go installation completed successfully"
log_message "Note: You may need to restart your terminal or run 'source ~/.profile' to use Go immediately"
