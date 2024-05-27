# Code2Context

`Code2Context` is a bash utility script designed for software development. It recursively prints the relative path and contents of each file in a directory, ignoring files and directories specified in an ignore file. The output is then copied to the clipboard, making it easy to provide comprehensive context to Large Language Models (LLMs) for various development tasks.

## Features

- Recursively lists all files in a directory.
- Prints the relative path and contents of each file.
- Ignores files and directories specified in `~/.code2contextignore`.
- Copies the output to the clipboard using `pbcopy`, `xclip`, or `xsel`.
- Supports `bash`, `zsh`, and `fish` shells.
- Facilitates providing comprehensive context to LLMs for software development.

## Installation

### Manual Installation

1. Download the script to your home directory:
    ```sh
    curl -o ./code2context.sh https://raw.githubusercontent.com/richardleighdavies/code2context/main/source/code2context.sh
    ```

2. Make the script executable:
    ```sh
    chmod +x ./code2context.sh
    ```

3. Move the script to `/usr/local/bin`:
    ```sh
    sudo mv ./code2context.sh /usr/local/bin/code2context
    ```

## Usage

1. Ensure you have a `.code2contextignore` file in your home directory with the paths you want to ignore. For example:
    ```text
    node_modules
    *.log
    dist
    ```

2. Run the script from any directory:
    ```sh
    code2context
    ```

3. The script will copy the relative paths and contents of all files (excluding ignored ones) to the clipboard, making it easy to paste into an LLM for software development context.

## Dependencies

- `pbcopy` (for macOS)
- `xclip` or `xsel` (for Linux)

Make sure you have one of these utilities installed. You can install `xclip` or `xsel` on Linux using the following commands:

```sh
# For xclip
sudo apt-get install xclip

# For xsel
sudo apt-get install xsel
```

## Development

To contribute to the development of this script, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/richardleighdavies/code2context.git
    ```

2. Make your changes and test thoroughly.

3. Submit a pull request with a detailed description of your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Inspired by the need to easily capture the contents of a directory structure for providing context to Large Language Models in software development.

---

For any questions or support, please open an issue on the [GitHub repository](https://github.com/richardleighdavies/code2context/issues).
