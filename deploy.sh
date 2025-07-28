#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
VERBOSE=false

# Platform detection
PLATFORM="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PLATFORM="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM="macos"
fi

# Package configuration
# Format: ["package_name"]="platform1 platform2" or "all" for all platforms
declare -A PACKAGE_PLATFORMS=(
  ["aerospace"]="macos"
  ["atuin"]="linux macos"
  ["ghostty"]="linux macos"
  ["git"]="linux macos"
  ["hypr"]="linux"
  ["lazydocker"]="linux macos"
  ["lazygit"]="linux macos"
  ["nvim"]="all"
  ["omarchy"]="linux"
  ["skhd"]="macos"
  ["starship"]="all"
  ["tmux"]="all"
  ["zsh"]="all"
)

# Functions
# Get packages for current platform
get_platform_packages() {
  local platform=$1
  local packages=()

  for package in "${!PACKAGE_PLATFORMS[@]}"; do
    local platforms="${PACKAGE_PLATFORMS[$package]}"
    if [[ "$platforms" == "all" ]] || [[ "$platforms" =~ $platform ]]; then
      packages+=("$package")
    fi
  done

  # Sort packages alphabetically
  IFS=$'\n' sorted=($(sort <<<"${packages[*]}"))
  unset IFS

  echo "${sorted[@]}"
}

# Get all available packages
get_all_packages() {
  local packages=()
  for package in "${!PACKAGE_PLATFORMS[@]}"; do
    packages+=("$package")
  done

  # Sort packages alphabetically
  IFS=$'\n' sorted=($(sort <<<"${packages[*]}"))
  unset IFS

  echo "${sorted[@]}"
}

print_usage() {
  cat <<EOF
Usage: $0 [OPTIONS] [COMMAND] [PACKAGES...]

Commands:
    install     Install dotfile packages (default)
    uninstall   Remove dotfile packages
    restow      Reinstall packages (useful for resolving conflicts)
    list        List available packages

Options:
    -a, --all       Apply to all packages
    -d, --dry-run   Show what would be done without doing it
    -b, --backup    Backup existing configs before stowing
    -v, --verbose   Enable verbose output
    -h, --help      Show this help message

Examples:
    $0 install zsh nvim     # Install zsh and nvim configs
    $0 --all install        # Install all packages
    $0 --dry-run uninstall  # Preview uninstall for all packages
    $0 list                 # List available packages
EOF
}

print_error() {
  echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
  echo -e "${GREEN}$1${NC}"
}

print_warning() {
  echo -e "${YELLOW}$1${NC}"
}

print_info() {
  echo -e "${BLUE}$1${NC}"
}

# Parse command line arguments
COMMAND="install"
PACKAGES=()
USE_ALL=false
BACKUP=false

while [[ $# -gt 0 ]]; do
  case $1 in
  -a | --all)
    USE_ALL=true
    shift
    ;;
  -d | --dry-run)
    DRY_RUN=true
    shift
    ;;
  -b | --backup)
    BACKUP=true
    shift
    ;;
  -v | --verbose)
    VERBOSE=true
    shift
    ;;
  -h | --help)
    print_usage
    exit 0
    ;;
  install | uninstall | restow | list)
    COMMAND=$1
    shift
    ;;
  -*)
    print_error "Unknown option: $1"
    print_usage
    exit 1
    ;;
  *)
    PACKAGES+=("$1")
    shift
    ;;
  esac
done

# If no packages specified and not using --all, show usage
if [[ ${#PACKAGES[@]} -eq 0 ]] && [[ "$USE_ALL" == false ]] && [[ "$COMMAND" != "list" ]]; then
  print_error "No packages specified. Use --all or specify packages."
  print_usage
  exit 1
fi

# Determine which packages to use
if [[ "$USE_ALL" == true ]]; then
  PACKAGES=($(get_platform_packages "$PLATFORM"))
fi

# Prerequisite checks
check_prerequisites() {
  # Check if stow is installed
  if ! command -v stow &>/dev/null; then
    print_error "GNU Stow is not installed."
    print_info "Please install it using your package manager:"
    print_info "  - Debian/Ubuntu: sudo apt install stow"
    print_info "  - macOS: brew install stow"
    print_info "  - Arch: sudo pacman -S stow"
    exit 1
  fi

  # Check if we're in the dotfiles directory
  if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
    print_warning "Not in a git repository. Are you in the dotfiles directory?"
  fi

  # Verify script is run from dotfiles directory
  if [[ "$PWD" != "$SCRIPT_DIR" ]]; then
    cd "$SCRIPT_DIR" || exit 1
    print_info "Changed to dotfiles directory: $SCRIPT_DIR"
  fi
}

# Validate packages exist
validate_packages() {
  local invalid_packages=()

  for package in "${PACKAGES[@]}"; do
    if [[ ! -d "$SCRIPT_DIR/$package" ]]; then
      invalid_packages+=("$package")
    fi
  done

  if [[ ${#invalid_packages[@]} -gt 0 ]]; then
    print_error "Invalid packages: ${invalid_packages[*]}"
    print_info "Available packages: $(get_all_packages)"
    exit 1
  fi
}

# Backup existing configurations
backup_configs() {
  if [[ "$BACKUP" != true ]]; then
    return
  fi

  print_info "Creating backup directory: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"

  for package in "${PACKAGES[@]}"; do
    # Find all files/dirs that would be stowed
    while IFS= read -r -d '' file; do
      # Get the relative path from package directory
      rel_path="${file#$package/}"
      target="$HOME/$rel_path"

      # If target exists and is not a symlink, back it up
      if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        backup_path="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        cp -r "$target" "$backup_path"
        print_info "Backed up: $target"
      fi
    done < <(find "$package" -type f -print0 2>/dev/null)
  done
}

# Run stow command with common options
run_stow() {
  local action=$1
  local package=$2
  local stow_opts=()

  # Build stow options
  stow_opts+=("--dir=$SCRIPT_DIR")
  stow_opts+=("--target=$HOME")

  if [[ "$VERBOSE" == true ]]; then
    stow_opts+=("--verbose=2")
  fi

  if [[ "$DRY_RUN" == true ]]; then
    stow_opts+=("--no")
    print_info "[DRY RUN] Would run: stow ${stow_opts[*]} $action $package"
  fi

  # Execute stow
  if stow "${stow_opts[@]}" "$action" "$package" 2>&1; then
    if [[ "$DRY_RUN" != true ]]; then
      print_success "Successfully ${action}ed: $package"
    fi
  else
    print_error "Failed to ${action} package: $package"
    return 1
  fi
}

# Install packages using stow
stow_packages() {
  print_info "Installing packages..."

  # Backup if requested
  backup_configs

  local failed_packages=()

  for package in "${PACKAGES[@]}"; do
    print_info "Installing $package..."
    if ! run_stow "--stow" "$package"; then
      failed_packages+=("$package")
    fi
  done

  if [[ ${#failed_packages[@]} -gt 0 ]]; then
    print_error "Failed to install packages: ${failed_packages[*]}"
    print_info "Try running with --verbose for more details"
    exit 1
  else
    print_success "All packages installed successfully!"
  fi
}

# Uninstall packages using stow
unstow_packages() {
  print_info "Uninstalling packages..."

  local failed_packages=()

  for package in "${PACKAGES[@]}"; do
    print_info "Uninstalling $package..."
    if ! run_stow "--delete" "$package"; then
      failed_packages+=("$package")
    fi
  done

  if [[ ${#failed_packages[@]} -gt 0 ]]; then
    print_error "Failed to uninstall packages: ${failed_packages[*]}"
    exit 1
  else
    print_success "All packages uninstalled successfully!"
  fi
}

# Restow packages (uninstall then reinstall)
restow_packages() {
  print_info "Restowing packages..."

  # Backup if requested
  backup_configs

  local failed_packages=()

  for package in "${PACKAGES[@]}"; do
    print_info "Restowing $package..."
    if ! run_stow "--restow" "$package"; then
      failed_packages+=("$package")
    fi
  done

  if [[ ${#failed_packages[@]} -gt 0 ]]; then
    print_error "Failed to restow packages: ${failed_packages[*]}"
    exit 1
  else
    print_success "All packages restowed successfully!"
  fi
}

# Execute command
case $COMMAND in
list)
  print_info "Available packages by platform:"
  echo

  # Display all packages with their supported platforms
  for package in $(get_all_packages); do
    printf "%-15s : %s\n" "$package" "${PACKAGE_PLATFORMS[$package]}"
  done

  echo
  print_info "Detected platform: $PLATFORM"
  print_info "Packages for this platform: $(get_platform_packages "$PLATFORM")"
  ;;
install | uninstall | restow)
  check_prerequisites
  validate_packages

  # Execute the appropriate action
  case $COMMAND in
  install)
    stow_packages
    ;;
  uninstall)
    unstow_packages
    ;;
  restow)
    restow_packages
    ;;
  esac
  ;;
*)
  print_error "Unknown command: $COMMAND"
  print_usage
  exit 1
  ;;
esac
