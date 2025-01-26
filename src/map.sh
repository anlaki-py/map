#!/bin/env bash

# Function to create the directory tree
create_tree() {
    local prefix="$1"
    local dir="$2"
    local output=""

    # List all files and directories, sorted alphabetically, excluding .git and __pycache__
    local items=($(ls -1A "$dir" | grep -vE '^(.git|__pycache__|.other|.old|cache|tmp|temp)$' | sort))

    for ((i=0; i<${#items[@]}; i++)); do
        local item="${items[$i]}"
        local path="$dir/$item"

        if [ -d "$path" ]; then
            if [ $((i+1)) -eq ${#items[@]} ]; then
                output+="${prefix}└── /$item\n"
                output+="$(create_tree "$prefix    " "$path")"
            else
                output+="${prefix}├── /$item\n"
                output+="$(create_tree "$prefix│   " "$path")"
            fi
        else
            if [ $((i+1)) -eq ${#items[@]} ]; then
                output+="${prefix}└── $item\n"
            else
                output+="${prefix}├── $item\n"
            fi
        fi
    done

    echo -n "$output"
}

# Get the current directory name
current_dir=$(basename "$(pwd)")

# Create the Markdown content
markdown_content="# Directory Structure\n\n\`\`\`\n/$current_dir\n$(create_tree "" ".")\n\`\`\`"

# Save the Markdown content to map.md
echo -e "$markdown_content" > map.md
cat map.md
echo ' '
echo "Directory structure has been saved to map.md"
