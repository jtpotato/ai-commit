swift build -c release

# create the bin folder if it doesn't exist
mkdir -p ~/bin

# moves the CLI to the folder
mv ./.build/arm64-apple-macosx/release/ai-commit ~/bin/

echo "ai-commit installed in ~/bin/ai-commit"
