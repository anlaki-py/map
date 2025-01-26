# MAP (Map Architect Pro)

### Installation for Linux
```bash
curl -sSL https://raw.githubusercontent.com/anlaki-py/map/main/setup.sh | sudo bash
```

### Installation for Termux
```bash
curl -sSL https://raw.githubusercontent.com/anlaki-py/map/main/setup.sh | bash
```

### Features

- Generates a visual tree-like structure of directories and files
- Supports mapping specific directories
- Interactive warning for large directories
- Extensive ignore list for system and development directories
- Customizable depth and output options

### Usage

```bash
# Show help
map -h
map --help

# Map current directory
map

# Map a specific directory
map Downloads
map ~/Documents
map /path/to/specific/directory

# Limit directory depth
map -d 3 Downloads

# Save output to a file
map -o directory_structure.md

# Customize warning thresholds
map -w 500 -m 2000 Projects
```

### Command-line Options

- `-h, --help`: Show help message
- `-d, --depth <number>`: Limit the depth of directory traversal (default: 10)
- `-o, --output <filename>`: Save output to a specific file
- `-w, --warning-threshold <number>`: Set the number of items that triggers a warning (default: 1000)
- `-m, --max-items <number>`: Set the maximum number of items allowed (default: 5000)

### Ignored Directories and Files

The script automatically excludes:
- Version control directories (`.git`, `.svn`)
- Python cache and environment directories
- Node.js dependencies
- IDE and editor files
- Build and temporary directories
- System and backup files
