#!/bin/bash

sudo apt install git

# Ensure EMAIL environment variable is set
if [ -z "$EMAIL" ]; then
  echo "Error: EMAIL environment variable is not set."
  exit 1
fi

# Generate the SSH key
echo "Generating SSH key with email: $EMAIL"
ssh-keygen -t ed25519 -C "$EMAIL"

# Path to the config file
SSH_CONFIG_FILE="$HOME/.ssh/config"

# Check if the file already exists
if [ -f "$SSH_CONFIG_FILE" ]; then
  # Ask user for permission to replace the file
  read -p "$SSH_CONFIG_FILE already exists. Do you want to replace it? (y/n): " REPLACE
  if [[ "$REPLACE" != "y" && "$REPLACE" != "Y" ]]; then
    echo "The file will not be replaced. Exiting without changes."
    exit 0
  fi
fi

# Create the ~/.ssh/config file with the specified content
mkdir -p "$HOME/.ssh"  # Ensure .ssh directory exists

cat > "$SSH_CONFIG_FILE" <<EOL
Host $HOST_NAME
  HostName github.com
  User git
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519
EOL

# Set appropriate permissions for the config file
chmod 600 "$SSH_CONFIG_FILE"

echo "SSH config file created at $SSH_CONFIG_FILE with host '$HOST_NAME'."