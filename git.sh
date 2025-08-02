#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Git installation and configuration..."

log_message "Installing Git..."
sudo apt install git -y 2>&1 | tee -a "$LOG_FILE"

# Ensure EMAIL environment variable is set
if [ -z "$EMAIL" ]; then
  log_error "EMAIL environment variable is not set"
  echo "Error: EMAIL environment variable is not set."
  exit 1
fi

log_message "Email configured: $EMAIL"

# Generate the SSH key
log_message "Generating SSH key with email: $EMAIL"
if ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N "" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "SSH key generated successfully"
else
    log_error "Failed to generate SSH key"
    exit 1
fi

# Path to the config file
SSH_CONFIG_FILE="$HOME/.ssh/config"

# Check if the file already exists
if [ -f "$SSH_CONFIG_FILE" ]; then
  log_message "SSH config file already exists: $SSH_CONFIG_FILE"
  # Ask user for permission to replace the file
  read -p "$SSH_CONFIG_FILE already exists. Do you want to replace it? (y/n): " REPLACE
  if [[ "$REPLACE" != "y" && "$REPLACE" != "Y" ]]; then
    log_message "SSH config file will not be replaced"
    echo "The file will not be replaced. Exiting without changes."
    exit 0
  fi
fi

# Create the ~/.ssh/config file with the specified content
log_message "Creating SSH config directory..."
mkdir -p "$HOME/.ssh" 2>&1 | tee -a "$LOG_FILE"

log_message "Creating SSH config file with host: $HOST_NAME"
cat > "$SSH_CONFIG_FILE" <<EOL
Host $HOST_NAME
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519
EOL

# Set appropriate permissions for the config file
chmod 600 "$SSH_CONFIG_FILE" 2>&1 | tee -a "$LOG_FILE"
log_message "SSH config file created at $SSH_CONFIG_FILE with host '$HOST_NAME'"

log_message "Git installation and configuration completed successfully"