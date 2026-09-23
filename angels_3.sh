#!/bin/bash
# Script to download AI models using Ollama, setup opencode and CLAUDE.md config

# absolute path of this script's folder, so links work from any folder
script_dir="$(cd "$(dirname "$0")" && pwd)"

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
echo "Ollama is not installed. Please install it first: https://ollama.ai"
exit 1
fi

# List of models to download
models=("deepseek-r1" "llama3.2" "qwen3-coder" "qwen3")

# Download each model
for model in "${models[@]}"; do
  echo "Pulling $model..."
  ollama pull "$model"
  if [ $? -ne 0 ]; then
    echo "Failed to pull $model"
    exit 1
  fi
done

echo "All models downloaded successfully!"

# setup config for opencode
mkdir -p ~/.config/opencode
ln -s "$script_dir/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -s "$script_dir/opencode/tui.json" ~/.config/opencode/tui.json
ln -s "$script_dir/opencode/package.json" ~/.config/opencode/package.json
echo "OpenCode config link successfully!"

# setup config for claude code
mkdir -p ~/.claude
ln -s "$script_dir/claude/CLAUDE.md" ~/.claude/CLAUDE.md
echo "CLAUDE.md link successfully!"
