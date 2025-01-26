#!/usr/bin/env bash

# Function to display help information
show_help() {
    echo "MAP (Map Architect Pro) - Directory Mapping Utility"
    echo ""
    echo "Usage: map [OPTIONS] [DIRECTORY]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo "  -d, --depth NUM           Limit directory traversal depth (default: 10)"
    echo "  -o, --output FILE         Save output to a specific file"
    echo "  -w, --warning-threshold NUM  Set number of items to trigger warning (default: 1000)"
    echo "  -m, --max-items NUM       Set maximum number of items allowed (default: 5000)"
    echo "  --update                  Update to the latest version"
    echo "  --uninstall               Remove the program"
    echo ""
    echo "Examples:"
    echo "  map                       Map current directory"
    echo "  map Downloads             Map specific directory"
    echo "  map -d 3 Downloads        Limit depth to 3 levels"
    echo "  map -o structure.md       Save output to file"
    echo "  map --update              Update to latest version"
    echo "  map --uninstall           Remove the program"
    echo ""
    echo "For more information, visit: https://github.com/anlaki-py/map"
}

# Configuration section
MAX_FILES_WARNING=1000  # Threshold for warning about large directories
MAX_FILES_ABSOLUTE=5000 # Absolute limit to prevent overwhelming output

# List of patterns to ignore
IGNORE_PATTERNS=(
    ".git" ".svn" ".hg"
    "__pycache__" ".pytest_cache" ".mypy_cache"
    "*.pyc" "*.pyo" "*.pyd"
    "venv" "env" ".venv" ".env"
    "virtualenv" ".virtualenv"
    "conda" ".conda"
    "node_modules" ".npm" ".yarn"
    ".vscode" ".idea"
    "*.sublime-project" "*.sublime-workspace"
    ".eclipse"
    "build" "dist"
    "*.egg-info" "target" "out"
    "*.log"
    ".tmp" ".temp" "tmp" "temp"
    "cache"
    "*.bak" "*~"
    ".DS_Store" "Thumbs.db"
    ".gradle" ".m2" ".cargo"
)

# Function to resolve full path
resolve_path() {
    local path="$1"
    
    # If path is relative, convert to absolute
    if [[ "$path" != /* ]]; then
        path="$(pwd)/$path"
    fi
    
    # Normalize path (remove .., redundant /, etc.)
    path=$(readlink -f "$path")
    
    # Check if path exists
    if [ ! -d "$path" ]; then
        echo "Error: Directory '$1' does not exist." >&2
        exit 1
    fi
    
    echo "$path"
}

# Function to count files and directories
count_files_and_dirs() {
    local dir="$1"
    local ignore_args=()
    
    for pattern in "${IGNORE_PATTERNS[@]}"; do
        ignore_args+=(-not -path "*/$pattern*" -not -name "$pattern")
    done

    find "$dir" -maxdepth 1 -mindepth 1 "${ignore_args[@]}" | wc -l
}

# Function to create the directory tree with interactive warning
create_tree() {
    local prefix="$1"
    local dir="$2"
    local max_depth="${3:-10}"
    local current_depth="${4:-0}"

    # Exit if max depth is reached
    if [ "$current_depth" -ge "$max_depth" ]; then
        return
    fi

    # Create ignore pattern for find command
    local ignore_args=()
    for pattern in "${IGNORE_PATTERNS[@]}"; do
        ignore_args+=(-not -path "*/$pattern*" -not -name "$pattern")
    done

    # Use find to list files and directories, respecting ignore patterns
    local items=()
    while IFS= read -r -d '' item; do
        items+=("$item")
    done < <(find "$dir" -maxdepth 1 -mindepth 1 "${ignore_args[@]}" -print0 | sort -z)

    local total_items=${#items[@]}

    # Check for large directory
    if [ "$total_items" -gt "$MAX_FILES_WARNING" ]; then
        echo "WARNING: Large directory detected (${total_items} items)" >&2
        
        if [ "$total_items" -gt "$MAX_FILES_ABSOLUTE" ]; then
            echo "ABORTED: Exceeded maximum allowed items (${MAX_FILES_ABSOLUTE})" >&2
            return
        fi

        # Interactive prompt
        read -p "Do you want to continue? (y/N): " response
        response=${response,,}  # convert to lowercase
        if [[ "$response" != "y" && "$response" != "yes" ]]; then
            echo "Operation cancelled." >&2
            return
        fi
    fi

    local output=""

    for ((i=0; i<total_items; i++)); do
        local item=$(basename "${items[$i]}")
        local path="${items[$i]}"

        if [ -d "$path" ]; then
            # Directory name
            local dir_name="/$item"
            
            if [ $((i+1)) -eq "$total_items" ]; then
                output+="${prefix}└── ${dir_name}\n"
                output+="$(create_tree "$prefix    " "$path" "$max_depth" $((current_depth+1)))"
            else
                output+="${prefix}├── ${dir_name}\n"
                output+="$(create_tree "$prefix│   " "$path" "$max_depth" $((current_depth+1)))"
            fi
        else
            # File name
            local file_name="$item"
            
            if [ $((i+1)) -eq "$total_items" ]; then
                output+="${prefix}└── $file_name\n"
            else
                output+="${prefix}├── $file_name\n"
            fi
        fi
    done

    echo -n "$output"
}

# New function: Handle self-update
handle_update() {
    echo "Checking for updates..."
    SCRIPT_URL="https://raw.githubusercontent.com/anlaki-py/map/main/src/map.sh"
    TEMP_FILE=$(mktemp)
    INSTALL_DIR=$(dirname "$(realpath "$0")")

    # Check for curl availability
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is required for updates" >&2
        exit 1
    fi

    # Download latest version
    if ! curl -fsSL "$SCRIPT_URL" -o "$TEMP_FILE"; then
        echo "Failed to download update" >&2
        exit 1
    fi

    # Verify downloaded script
    if ! head -n 1 "$TEMP_FILE" | grep -q '^#!/bin/env bash'; then
        echo "Invalid script downloaded" >&2
        rm "$TEMP_FILE"
        exit 1
    fi

    # Replace existing installation
    if ! sudo mv "$TEMP_FILE" "$INSTALL_DIR/map"; then
        echo "Failed to install update" >&2
        exit 1
    fi

    sudo chmod +x "$INSTALL_DIR/map"
    echo "Successfully updated to latest version"
    exit 0
}

# New function: Handle uninstallation
handle_uninstall() {
    INSTALL_DIR=$(dirname "$(realpath "$0")")
    echo "This will remove map from $INSTALL_DIR"
    read -p "Are you sure? (y/N): " response
    response=${response,,}

    if [[ "$response" =~ ^(y|yes)$ ]]; then
        if sudo rm -f "$INSTALL_DIR/map"; then
            echo "map successfully uninstalled"
        else
            echo "Failed to uninstall map" >&2
            exit 1
        fi
    else
        echo "Uninstallation cancelled"
    fi
    exit 0
}

# Main script logic
main() {
    # Parse command-line arguments
    local max_depth=1000
    local output_file=""
    local warn_threshold=$MAX_FILES_WARNING
    local max_items=$MAX_FILES_ABSOLUTE
    local target_dir="."

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--depth)
                max_depth="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -w|--warning-threshold)
                warn_threshold="$2"
                shift 2
                ;;
            -m|--max-items)
                max_items="$2"
                shift 2
                ;;
            --update)
                handle_update
                ;;
            --uninstall)
                handle_uninstall
                ;;
            *)
                # Treat last non-flag argument as target directory
                target_dir="$1"
                shift
                ;;
        esac
    done

    # Resolve full path of target directory
    target_dir=$(resolve_path "$target_dir")

    # Dynamically update global thresholds
    MAX_FILES_WARNING=$warn_threshold
    MAX_FILES_ABSOLUTE=$max_items

    # Get the directory name for display
    local current_dir=$(basename "$target_dir")

    # Change to target directory for processing
    cd "$target_dir" || exit 1

    # Generate tree
    local tree_content="# Directory Structure\n\n\`\`\`\n/$current_dir\n$(create_tree "" "." "$max_depth")\n\`\`\`"

    # Output handling
    if [ -n "$output_file" ]; then
        echo -e "$tree_content" > "$output_file"
        echo "Directory structure saved to $output_file"
    else
        echo -e "$tree_content"
    fi
}

# Run the main function with arguments
main "$@"
