#!/bin/bash
# Script to download AI models using Ollama

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
