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

- Generates a visual tree-like structure of directories and files.
- Supports mapping specific directories.
- Interactive warning for large directories.
- Extensive ignore list for system and development directories.
- Customizable depth and output options.
- Built-in update and uninstall functionality.

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

# Update to the latest version
map --update

# Uninstall the program
map --uninstall
```

### Command-line Options

- `-h, --help`: Show help message.
- `-d, --depth <number>`: Limit the depth of directory traversal (default: 10).
- `-o, --output <filename>`: Save output to a specific file.
- `-w, --warning-threshold <number>`: Set the number of items that triggers a warning (default: 1000).
- `-m, --max-items <number>`: Set the maximum number of items allowed (default: 5000).
- `--update`: Update to the latest version of the script.
- `--uninstall`: Remove the program from your system.

### Ignored Directories and Files

The script automatically excludes:
- Version control directories (`.git`, `.svn`, `.hg`).
- Python cache and environment directories (`__pycache__`, `.pytest_cache`, `.mypy_cache`, `venv`, `.venv`, etc.).
- Node.js dependencies (`node_modules`, `.npm`, `.yarn`).
- IDE and editor files (`.vscode`, `.idea`, `.sublime-project`, `.sublime-workspace`, `.eclipse`).
- Build and temporary directories (`build`, `dist`, `target`, `out`, `.tmp`, `.temp`, `tmp`, `temp`).
- System and backup files (`.DS_Store`, `Thumbs.db`, `*.bak`, `*~`).

### Notes

- The script works seamlessly on both Linux and Termux environments.
- For large directories, the script provides an interactive prompt to confirm continuation.
- Use the `--update` option to ensure you always have the latest version of the script.
- Use the `--uninstall` option to safely remove the program from your system.
