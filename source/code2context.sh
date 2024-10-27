#!/usr/bin/env zsh

IGNORE_FILE="${HOME}/.code2contextignore"

read_ignore_patterns() {
    if [[ -f "${IGNORE_FILE}" ]]; then
        # Read patterns into an array, ignoring comments
        grep -v '^#' "${IGNORE_FILE}" || true
    fi
}

output_file_content() {
    local filepath="${1}"
    local relative_path="${filepath#./}"

    # Check if the file should be ignored
    for pattern in "${IGNORE_PATTERNS[@]}"; do
        if [[ "${relative_path}" == ${pattern} || "${relative_path}" == ${pattern}/* ]]; then
            return  # Skip this file if it matches the ignore pattern
        fi
    done

    # If not ignored, output the file information in the specified format
    print "**${relative_path}**"
    print '```'
    cat "${filepath}" || print "Error: Unable to read ${filepath}"
    print '```'
    print
}

copy_to_clipboard() {
    if (( ${+commands[pbcopy]} )); then
        pbcopy
    elif (( ${+commands[xclip]} )); then
        xclip -selection clipboard
    elif (( ${+commands[xsel]} )); then
        xsel --clipboard --input
    else
        print "Warning: No clipboard utility found. Outputting to stdout."
        cat
    fi
}

main() {
    local dir="${1:-.}"
    IGNORE_PATTERNS=("${(@f)$(read_ignore_patterns)}")

    # Find files and process each one
    find "${dir}" -type f -print0 | while IFS= read -r -d '' filepath; do
        output_file_content "${filepath}"
    done | copy_to_clipboard

    print "Content copied to clipboard. Use Ctrl+V to paste."
}

main "$@"
