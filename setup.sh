#!/usr/bin/env bash

# Exit immediately on errors, unset variables, and pipe failures
set -euo pipefail

# Constants and Configuration
SCRIPT_NAME="map"
SCRIPT_URL="https://raw.githubusercontent.com/anlaki-py/map/main/src/map.sh"
TMP_FILE=$(mktemp)

# Detect if running on Termux
if [[ -n "${TERMUX_APP_PACKAGE:-}" ]]; then
    # Running in Termux
    INSTALL_DIR="${PREFIX}/bin"
else
    # Running in regular Linux
    INSTALL_DIR="/usr/local/bin"
fi

# Color setup (only when connected to terminal)
if [[ -t 1 ]]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    CYAN=$(tput setaf 6)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED="" GREEN="" YELLOW="" CYAN="" BOLD="" RESET=""
fi

# Error handling function
error_exit() {
    echo -e "${RED}${BOLD}Error:${RESET} ${RED}$1${RESET}" >&2
    rm -f "$TMP_FILE" &>/dev/null
    exit "${2:-1}"
}

# Check required dependencies
check_dependencies() {
    local missing=()
    for cmd in curl; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error_exit "Missing required dependencies: ${missing[*]}"
    fi
}

# Check write permissions
check_permissions() {
    if [[ ! -w "$INSTALL_DIR" ]] && [[ ! -w "$(dirname "$INSTALL_DIR")" ]]; then
        echo -e "${YELLOW}Root privileges required for installation to ${INSTALL_DIR}${RESET}"
        if ! sudo -v &>/dev/null; then
            error_exit "Failed to obtain root privileges"
        fi
        SUDO_CMD="sudo"
    else
        SUDO_CMD=""
    fi
}

# Installation function
install_script() {
    echo -e "${CYAN}Downloading ${SCRIPT_NAME}...${RESET}"
    
    if ! curl -fsSL --retry 3 --connect-timeout 30 "$SCRIPT_URL" -o "$TMP_FILE"; then
        error_exit "Failed to download script from ${SCRIPT_URL}"
    fi

    # Basic script validation
    if [[ ! -s "$TMP_FILE" ]] || ! head -1 "$TMP_FILE" | grep -q '^#!/'; then
        error_exit "Downloaded file is not a valid script"
    fi

    echo -e "${CYAN}Installing to ${INSTALL_DIR}...${RESET}"
    $SUDO_CMD mv -f "$TMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME" || error_exit "Installation failed"
    $SUDO_CMD chmod +x "$INSTALL_DIR/$SCRIPT_NAME" || error_exit "Permission modification failed"

    # Verify installation
    if ! command -v "$SCRIPT_NAME" &>/dev/null; then
        error_exit "Installation verification failed. Ensure ${INSTALL_DIR} is in your PATH"
    fi

    echo -e "${GREEN}${BOLD}Success:${RESET} ${SCRIPT_NAME} installed to ${CYAN}${INSTALL_DIR}${RESET}"
}

# Uninstallation function
uninstall_script() {
    if [[ ! -f "${INSTALL_DIR}/${SCRIPT_NAME}" ]]; then
        error_exit "${SCRIPT_NAME} is not installed"
    fi

    check_permissions
    echo -e "${YELLOW}Removing ${SCRIPT_NAME}...${RESET}"
    $SUDO_CMD rm -f "${INSTALL_DIR}/${SCRIPT_NAME}" || error_exit "Uninstallation failed"
    echo -e "${GREEN}${BOLD}Success:${RESET} ${SCRIPT_NAME} has been removed"
}

# User interaction
prompt_user() {
    echo -e "${YELLOW}${SCRIPT_NAME} is already installed.${RESET}"
    echo "1) Update to latest version"
    echo "2) Uninstall"
    echo "3) Cancel installation"
    
    while true; do
        read -rp "${BOLD}Enter choice [1-3]: ${RESET}" choice
        case "$choice" in
            1) install_script; break ;;
            2) uninstall_script; break ;;
            3) echo -e "${YELLOW}Operation cancelled${RESET}"; exit 0 ;;
            *) echo -e "${RED}Invalid choice, try again${RESET}" ;;
        esac
    done
}

# Main execution flow
main() {
    check_dependencies

    # Detect Termux environment
    if [[ -n "${TERMUX_APP_PACKAGE:-}" ]]; then
        INSTALL_DIR="${PREFIX}/bin"
    else
        INSTALL_DIR="/usr/local/bin"
    fi

    check_permissions

    if command -v "$SCRIPT_NAME" &>/dev/null; then
        prompt_user
    else
        install_script
    fi

    rm -f "$TMP_FILE" &>/dev/null
}

# Cleanup on exit
trap 'rm -f "$TMP_FILE" &>/dev/null' EXIT

# Start main process
main
