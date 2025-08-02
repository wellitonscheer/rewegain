# Rewegain - Ubuntu Setup Automation

A collection of shell scripts to automate the installation and configuration of essential software and tools on Ubuntu systems. This project eliminates the tedious process of manually installing and configuring applications after a fresh Ubuntu installation.

## Purpose

After a fresh Ubuntu installation, it's time-consuming and annoying to remember and manually install all the applications and tools you had in your previous setup. This project automates that process by providing a set of scripts that install and configure commonly used software.

## Note

This project was created for my personal use, so some configurations and choices are specific to my setup and preferences. However, feel free to use, modify, and adapt it for your own needs!

## Quick Start

### Prerequisites
- Ubuntu (or Ubuntu-based distribution)
- Internet connection
- Sudo privileges

### Installation

1. Clone or download this repository:
```bash
git clone <repository-url>
cd rewegain
```

2. Make the main script executable:
```bash
chmod +x main.sh
```

3. Run the main script:
```bash
./main.sh
```

The script will prompt for your email address when needed (for Git SSH key generation).

The script will automatically:
- Update the system
- Install required dependencies
- Execute all individual installation scripts
- Configure your environment

## What Gets Installed

- Brave Browser
- Visual Studio Code
- Bitwarden (with alias `bit`)
- Git (with SSH key generation)
- System dependencies (curl, libfuse2t64, etc.)

### Download Failures

Some scripts download files from external sources. If downloads fail:
- Check your internet connection
- Verify the download URLs are still valid
- Try running the script again

## Notes

- All scripts are designed to be idempotent (safe to run multiple times)
- Aliases and configurations are added to `.bashrc`
- The system is updated and upgraded after all installations
- Some applications may require manual configuration after installation
- All installation activities are logged to `rewegain_install.log` in the project directory for troubleshooting 