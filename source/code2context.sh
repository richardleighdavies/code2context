#!/bin/bash

IGNORE_FILE="$HOME/.code2contextignore"
IGNORE_PATHS=()

# Function to read ignore file into an array
# Arguments:
#   None
# Outputs:
#   An array of ignore paths
read_ignore_file() {
  local ignore_file="$1"
  local -n ignore_paths=$2
  ignore_paths=()
  
  if [[ -f "$ignore_file" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      ignore_paths+=("$line")
    done < "$ignore_file"
  fi
}

# Function to check if a given path should be ignored
# Arguments:
#   $1 - The path to check
#   $2 - The array of ignore paths
# Returns:
#   0 if the path should be ignored, 1 otherwise
should_ignore() {
  local path="$1"
  local -n ignore_paths=$2
  for ignore in "${ignore_paths[@]}"; do
    if [[ "$path" == "$ignore" ]] || [[ "$path" == "$ignore/"* ]]; then
      return 0
    fi
  done
  return 1
}

# Recursive function to process directories and accumulate file paths and contents
# Arguments:
#   $1 - The directory to process
#   $2 - The array of ignore paths
#   $3 - The name of the output variable to accumulate the result
process_directory() {
  local dir="$1"
  local -n ignore_paths=$2
  local -n output=$3
  shopt -s nullglob
  local entry

  for entry in "$dir"/*; do
    [[ -e "$entry" ]] || continue
    local relative_path="${entry#./}"
    if should_ignore "$relative_path" ignore_paths; then
      continue
    fi

    if [[ -d "$entry" ]]; then
      process_directory "$entry" ignore_paths output
    elif [[ -f "$entry" ]]; then
      output+="File: $relative_path"$'\n'
      output+="Content:"$'\n'
      output+="$(cat "$entry")"$'\n\n'
    fi
  done
}

# Main function to orchestrate the script
main() {
  local ignore_paths
  local output

  read_ignore_file "$IGNORE_FILE" ignore_paths
  process_directory "." ignore_paths output

  # Copy the output to the clipboard based on the detected shell
  case "$SHELL" in
    */bash|*/zsh)
      if command -v pbcopy &> /dev/null; then
        echo "$output" | pbcopy
      elif command -v xclip &> /dev/null; then
        echo "$output" | xclip -selection clipboard
      elif command -v xsel &> /dev/null; then
        echo "$output" | xsel --clipboard --input
      else
        echo "No clipboard utility found. Please install pbcopy, xclip, or xsel."
        exit 1
      fi
      ;;
    */fish)
      if command -v pbcopy &> /dev/null; then
        echo "$output" | pbcopy
      elif command -v xclip &> /dev/null; then
        echo "$output" | xclip -selection clipboard
      elif command -v xsel &> /dev/null; then
        echo "$output" | xsel --clipboard --input
      else
        echo "No clipboard utility found. Please install pbcopy, xclip, or xsel."
        exit 1
      fi
      ;;
    *)
      echo "Unsupported shell. Please use bash, zsh, or fish."
      exit 1
      ;;
  esac
}

# Run the main function
main
