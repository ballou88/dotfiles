#!/bin/bash

# Script to find files in stow directories that are not tracked by git

# Get the directory where the script is located (should be the dotfiles root)
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print usage
usage() {
    echo "Usage: $0 [OPTIONS] [STOW_PACKAGE]"
    echo ""
    echo "Find files in stow directories that are not tracked by git."
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Show verbose output (including tracked files)"
    echo ""
    echo "Arguments:"
    echo "  STOW_PACKAGE   Optional: Check only a specific stow package"
    echo ""
    echo "Examples:"
    echo "  $0              # Check all stow packages"
    echo "  $0 nvim         # Check only the nvim stow package"
    echo "  $0 -v           # Show verbose output for all packages"
}

# Parse arguments
VERBOSE=false
SPECIFIC_PACKAGE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            SPECIFIC_PACKAGE="$1"
            shift
            ;;
    esac
done

# Change to dotfiles directory
cd "$DOTFILES_DIR" || exit 1

# Get list of all files tracked by git
git_files=$(git ls-files)

# Function to check if a file is tracked by git
is_tracked() {
    local file="$1"
    echo "$git_files" | grep -q "^$file$"
}

# Function to process a stow package
process_stow_package() {
    local package="$1"
    local untracked_count=0
    
    echo -e "${YELLOW}Checking stow package: $package${NC}"
    
    # Find all files in the package directory (excluding .git and .claude)
    while IFS= read -r -d '' file; do
        # Remove the leading ./ if present
        file="${file#./}"
        
        if is_tracked "$file"; then
            if [[ "$VERBOSE" == "true" ]]; then
                echo -e "  ${GREEN}[TRACKED]${NC} $file"
            fi
        else
            echo -e "  ${RED}[UNTRACKED]${NC} $file"
            ((untracked_count++))
        fi
    done < <(find "$package" -type f -not -path "*/.git/*" -not -path "*/.claude/*" -print0 2>/dev/null)
    
    if [[ $untracked_count -eq 0 ]]; then
        echo -e "  ${GREEN}All files are tracked!${NC}"
    else
        echo -e "  ${RED}Found $untracked_count untracked file(s)${NC}"
    fi
    echo ""
}

# Main logic
if [[ -n "$SPECIFIC_PACKAGE" ]]; then
    # Check specific package
    if [[ -d "$SPECIFIC_PACKAGE" ]]; then
        process_stow_package "$SPECIFIC_PACKAGE"
    else
        echo -e "${RED}Error: Stow package '$SPECIFIC_PACKAGE' not found${NC}"
        exit 1
    fi
else
    # Check all stow packages
    total_untracked=0
    
    # Find all directories in the dotfiles root (these are stow packages)
    # Exclude .git directory but include other hidden directories
    for dir in */ .[^.]*/; do
        # Remove trailing slash
        dir="${dir%/}"
        
        # Skip .git and .claude directories
        if [[ "$dir" == ".git" ]] || [[ "$dir" == ".claude" ]]; then
            continue
        fi
        
        # Skip if not a directory
        if [[ ! -d "$dir" ]]; then
            continue
        fi
        
        process_stow_package "$dir"
    done
fi