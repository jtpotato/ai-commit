Here’s a revised README that enhances clarity, structure, and professionalism while retaining the original intent of your project:

---

# ai-commit

**ai-commit** is a command-line interface (CLI) tool that generates AI-assisted Git commit messages. Written in Swift based on the assumption that most Ollama users are going to have a Mac.

## Features

- Built entirely in Swift for performance and distaste of JavaScript.
- Utilizes Ollama for generating meaningful commit messages, avoiding the need for external APIs.

## Installation

To install **ai-commit**, you'll need to build it from source. Follow the steps below:

1. **Clone the Repository**:

   ```sh
   git clone "https://github.com/jtpotato/ai-commit" --depth=1
   cd ai-commit
   ```

2. **Run the Installation Script**:

   ```sh
   zsh install.sh
   ```

3. **Update Your PATH** (if necessary):
   If this is your first binary installation, you may need to add `~/bin` to your system's PATH:

   ```sh
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Clean Up**:
   Remove the repository after installation:
   ```sh
   cd ..
   rm -rf ./ai-commit
   ```

## Usage

After installation, you can use `ai-commit` to generate commit messages. There are no arguments, the CLI will guide you through it!

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have any improvements or new features to add.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Ollama
- OllamaKit
- Swift Argument Parser

---

Feel free to modify any sections to better suit your project’s style or add any additional information that you think might be relevant!

README mostly generated with ChatGPT.
