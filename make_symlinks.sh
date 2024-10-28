#!/bin/bash

# Directory to store symbolic links
LINK_DIR="$HOME/LazyVimFiles"

# Create the directory if it doesn't exist
mkdir -p "$LINK_DIR"

# Function to create or overwrite a symbolic link
create_link() {
  local source_path="$1"
  local link_name=$(basename "$source_path")
  local link_path="$LINK_DIR/$link_name"

  # Remove existing symlink if it exists
  if [ -L "$link_path" ]; then
    rm "$link_path"
  fi

  # Create the new symlink
  ln -s "$source_path" "$link_path"
  echo "Created/Updated symlink: $link_path -> $source_path"
}

# Function to check if a file should be skipped
should_skip() {
  local file="$1"

  # Skip lock files
  if [[ "$file" == *"lock.json" || "$file" == *"lock.yaml" || "$file" == *"lock.yml" ]]; then
    return 0
  fi

  # Skip files in the public folder
  if [[ "$file" == *"/public/"* ]]; then
    return 0
  fi

  # Skip image files (add more extensions if needed)
  if [[ "$file" == *.png || "$file" == *.jpg || "$file" == *.jpeg || "$file" == *.gif || "$file" == *.svg ]]; then
    return 0
  fi

  # Skip coverage.json
  if [[ "$file" == *"coverage.json" ]]; then
    return 0
  fi

  # Skip this script itself
  if [[ "$file" == *"make_symlinks.sh" ]]; then
    return 0
  fi

  return 1
}

# Use tree command and process its output
tree -I 'node_modules|cache|artifacts|coverage|typechain-types' --dirsfirst -L 5 -if --noreport | while IFS= read -r line; do
  # Skip the first line (root directory)
  if [ "$line" != "." ]; then
    # Check if it's a file (not a directory) and shouldn't be skipped
    if [ -f "$line" ] && ! should_skip "$line"; then
      create_link "$(pwd)/$line"
    fi
  fi
done

echo "Symbolic links created/updated in $LINK_DIR"
