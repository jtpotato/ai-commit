# ai-commit

Like all the other AI-generated git commit CLIs out there, but this one is written in Swift.

That is all.

Uses ollama to generate commits because why would you want to call ChatGPT for this?

# Installation
Build from source. Here's a bunch of shell commands that should make that pretty easy

```sh
git clone "https://github.com/jtpotato/ai-commit" --depth=1
cd ai-commit
swift build -c release

# if you don't have a folder to put the CLI in:
mkdir -p ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc

# moves the CLI to the folder
mv ./.build/arm64-apple-macosx/release/ai-commit ~/bin/mycli

# deletes the repository
cd ..
rm -rf ./ai-commit
```
