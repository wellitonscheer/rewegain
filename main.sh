#!/bin/bash

# Check if email is passed as a parameter
if [ -z "$1" ]; then
  echo "Error: No email provided."
  echo "Usage: $0 your_email@example.com"
  exit 1
fi

# Use the provided email from the first parameter
export EMAIL="$1"
export HOST_NAME="caie-pc"

sudo apt update
sudo apt install curl
sudo add-apt-repository universe
sudo apt install libfuse2t64

SHELL_CONFIG="$HOME/.bashrc"
# Get the directory of the current script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Find all .sh files in the directory, excluding main.sh itself
SH_FILES=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.sh" ! -name "main.sh")

# Give execute permission to all .sh files
echo "Giving execute permissions to all .sh files in the directory..."
for FILE in $SH_FILES; do
    chmod +x "$FILE"
    echo "Permissions set for: $FILE"
done

# Run all .sh files
echo "Running all .sh files..."
for FILE in $SH_FILES; do
    echo "Running $FILE..."
    "$FILE"
done

# Fix missing dependencies
echo "Fixing dependencies..."
sudo apt-get install -f -y

sudo apt update
sudo apt upgrade

# Reload shell config
source "$SHELL_CONFIG"

echo "All scripts have been executed successfully!"
