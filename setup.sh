#!/bin/bash

# Determine installation directory
if [[ "$(uname -o)" == "Android" ]]; then
    INSTALL_DIR="$PREFIX/bin"
else
    INSTALL_DIR="/usr/local/bin"
fi

SCRIPT_NAME="map"
SCRIPT_URL="https://raw.githubusercontent.com/anlaki-py/map/main/src/map.sh"

# Download and install the script
install_script() {
    echo "Downloading and installing $SCRIPT_NAME..."
    curl -sSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME" || { echo "Failed to download $SCRIPT_NAME."; exit 1; }
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    echo "$SCRIPT_NAME installed successfully at $INSTALL_DIR."
}

# Uninstall the script
uninstall_script() {
    echo "Uninstalling $SCRIPT_NAME..."
    rm -f "$INSTALL_DIR/$SCRIPT_NAME" || { echo "Failed to uninstall $SCRIPT_NAME."; exit 1; }
    echo "$SCRIPT_NAME has been uninstalled."
}

# Check if the script is already installed
if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
    echo "$SCRIPT_NAME is already installed."
    echo "What would you like to do?"
    echo "1) Overwrite with the new version"
    echo "2) Uninstall"
    echo "3) Cancel"
    read -rp "Enter your choice (1-3): " choice

    case $choice in
        1) install_script ;;
        2) uninstall_script ;;
        3) echo "Installation cancelled." ;;
        *) echo "Invalid choice. Exiting."; exit 1 ;;
    esac
else
    install_script
fi