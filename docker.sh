#!/bin/bash

# Source logging setup
source "$(dirname "$(realpath "$0")")/logging.sh"

log_message "Starting Docker installation..."

# Check if required dependencies are available
if ! command -v curl &> /dev/null; then
    log_error "curl is required but not installed"
    exit 1
fi

# Remove conflicting packages
log_message "Removing conflicting packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    log_message "Attempting to remove $pkg..."
    sudo apt-get remove -y $pkg 2>&1 | tee -a "$LOG_FILE"
done
log_message "Conflicting packages removal completed"

# Set up Docker's apt repository
log_message "Setting up Docker's apt repository..."

# Update package index
log_message "Updating package index..."
if sudo apt-get update 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Package index updated successfully"
else
    log_error "Failed to update package index"
    exit 1
fi

# Install prerequisites
log_message "Installing ca-certificates and curl..."
if sudo apt-get install -y ca-certificates curl 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Prerequisites installed successfully"
else
    log_error "Failed to install prerequisites"
    exit 1
fi

# Create keyrings directory
log_message "Creating keyrings directory..."
if sudo install -m 0755 -d /etc/apt/keyrings 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Keyrings directory created successfully"
else
    log_error "Failed to create keyrings directory"
    exit 1
fi

# Add Docker's official GPG key
log_message "Adding Docker's official GPG key..."
if sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker GPG key added successfully"
else
    log_error "Failed to add Docker GPG key"
    exit 1
fi

# Set permissions on GPG key
log_message "Setting permissions on GPG key..."
if sudo chmod a+r /etc/apt/keyrings/docker.asc 2>&1 | tee -a "$LOG_FILE"; then
    log_message "GPG key permissions set successfully"
else
    log_error "Failed to set GPG key permissions"
    exit 1
fi

# Add Docker repository to apt sources
log_message "Adding Docker repository to apt sources..."
if echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker repository added successfully"
else
    log_error "Failed to add Docker repository"
    exit 1
fi

# Update package index again
log_message "Updating package index with Docker repository..."
if sudo apt-get update 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Package index updated successfully"
else
    log_error "Failed to update package index"
    exit 1
fi

# Install Docker packages
log_message "Installing Docker packages (docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin)..."
if sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker packages installed successfully"
else
    log_error "Failed to install Docker packages"
    exit 1
fi

# Create docker group
log_message "Creating docker group..."
if sudo groupadd docker 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker group created successfully"
else
    # Group might already exist, check if that's the case
    if getent group docker > /dev/null 2>&1; then
        log_message "Docker group already exists"
    else
        log_error "Failed to create docker group"
        exit 1
    fi
fi

# Add current user to docker group
log_message "Adding user $USER to docker group..."
if sudo usermod -aG docker $USER 2>&1 | tee -a "$LOG_FILE"; then
    log_message "User $USER added to docker group successfully"
else
    log_error "Failed to add user to docker group"
    exit 1
fi

# Verify Docker installation
log_message "Verifying Docker installation with hello-world image..."
if sudo docker run hello-world 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker installation verified successfully"
else
    log_error "Docker installation verification failed"
    exit 1
fi

# Get installed Docker version
log_message "Checking installed Docker version..."
if docker --version 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker version check completed"
else
    log_message "Warning: Could not check Docker version (may require re-login for group permissions)"
fi

# Get installed Docker Compose version
log_message "Checking installed Docker Compose version..."
if docker compose version 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Docker Compose version check completed"
else
    log_message "Warning: Could not check Docker Compose version (may require re-login for group permissions)"
fi

log_message "Docker installation completed successfully"
log_message "IMPORTANT: You need to log out and log back in (or restart) for docker group membership to take effect"
log_message "After re-login, you can run docker commands without sudo"
