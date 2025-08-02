#!/bin/bash

# Variables
DEB_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
DEB_FILE="$HOME/Downloads/programs/code_latest_amd64.deb"

# Download Visual Studio Code .deb package
echo "Downloading Visual Studio Code .deb package..."
curl -L "$DEB_URL" -o "$DEB_FILE"

# Check if download was successful
if [ ! -f "$DEB_FILE" ]; then
  echo "Download failed. Please check the URL or your network connection."
  exit 1
fi

# Install the .deb package
echo "Installing Visual Studio Code..."
sudo dpkg -i "$DEB_FILE"

echo "Visual Studio Code installed successfully! You can launch it by typing 'code'."
