# Rewegain Script Requirements

This document outlines the requirements and standards for creating new installation scripts in the Rewegain project.

## Script Structure

Every installation script must follow this structure:

```bash
#!/bin/bash

# Use shared logging setup from main.sh
# LOG_FILE and logging functions are exported by main.sh

log_message "Starting [Application] installation..."

# Your installation logic here
# Always use 2>&1 | tee -a "$LOG_FILE" for commands that produce output

log_message "[Application] installation completed successfully"
```

## Required Elements

### 1. Logging Setup
- Every script must include the logging setup at the top
- Use `log_message()` for informational messages
- Use `log_error()` for error messages
- All command output must be captured with `2>&1 | tee -a "$LOG_FILE"`

### 2. Script Identification
- Replace `[Script Name]` with the actual application name in log messages
- Use consistent naming in log messages

### 3. Error Handling
- Check for required environment variables (like `$EMAIL` if needed)
- Validate file downloads and installations
- Exit with appropriate error codes on failure
- Log all errors with `log_error()`

### 4. Command Output Capture
- All commands that produce output must use: `command 2>&1 | tee -a "$LOG_FILE"`
- This ensures both console output and log file capture

### 5. Success/Failure Logging
- Log the start of installation
- Log successful completion
- Log any failures with details

## File Naming Convention

- Use lowercase with underscores: `application_name.sh`
- Be descriptive but concise
- Examples: `brave_browser.sh`, `vs_code.sh`, `git.sh`

## Installation Patterns

### Package Manager Installation
```bash
log_message "Installing [Application] via package manager..."
sudo apt install package-name -y 2>&1 | tee -a "$LOG_FILE"
```

### Download and Install
```bash
log_message "Downloading [Application]..."
if curl -L "URL" -o "local_file" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Download completed"
else
    log_error "Download failed"
    exit 1
fi

log_message "Installing [Application]..."
if sudo dpkg -i "local_file" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Installation successful"
else
    log_error "Installation failed"
    exit 1
fi
```

### AppImage Installation
```bash
log_message "Downloading [Application] AppImage..."
cd "$APP_DIR" || {
    log_error "Failed to change to Applications directory"
    exit 1
}

curl -LOJ "APPIMAGE_URL" 2>&1 | tee -a "$LOG_FILE"

# Find and make executable
APPIMAGE_PATH=$(find "$APP_DIR" -type f -name 'AppName*.AppImage' | head -n 1)
chmod +x "$APPIMAGE_PATH" 2>&1 | tee -a "$LOG_FILE"
```

### Alias Creation
```bash
ALIAS_LINE="alias alias_name=\"command\""
if ! grep -Fq "$ALIAS_LINE" "$SHELL_CONFIG"; then
    echo "$ALIAS_LINE" >> "$SHELL_CONFIG" 2>&1 | tee -a "$LOG_FILE"
    log_message "Alias added to $SHELL_CONFIG"
else
    log_message "Alias already exists in $SHELL_CONFIG"
fi
```

## Environment Variables

Available environment variables:
- `$EMAIL` - User's email address (set by main.sh)
- `$HOST_NAME` - Host name for SSH config (set by main.sh)
- `$SHELL_CONFIG` - Path to shell config file (set by main.sh)

## Testing Requirements

Before submitting a new script:
1. Test on a fresh Ubuntu installation
2. Verify all commands work as expected
3. Check that logging captures all output
4. Ensure error handling works properly
5. Test idempotency (safe to run multiple times)

## Common Pitfalls to Avoid

1. **Missing error handling** - Always check command exit codes
2. **No logging** - Every action must be logged
3. **Hardcoded paths** - Use environment variables when possible
4. **No user feedback** - Provide clear success/failure messages
5. **Missing dependencies** - Document and install required dependencies

## Example Complete Script

```bash
#!/bin/bash

# Use shared logging setup from main.sh
# LOG_FILE and logging functions are exported by main.sh

log_message "Starting Example App installation..."

# Check dependencies
if ! command -v curl &> /dev/null; then
    log_error "curl is required but not installed"
    exit 1
fi

# Installation logic
log_message "Installing Example App..."
if sudo apt install example-app -y 2>&1 | tee -a "$LOG_FILE"; then
    log_message "Example App installed successfully"
else
    log_error "Example App installation failed"
    exit 1
fi

log_message "Example App installation completed successfully"
``` 