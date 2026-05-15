#!/usr/bin/env bash

# === Requiring ~41.2GB of free space ===

# ~20GB
mkdir -p models/unsloth
curl -L -o models/unsloth/gemma-4-26B-A4B-it-UD-Q5_K_XL.gguf \
  https://huggingface.co/unsloth/gemma-4-26B-A4B-it-GGUF/resolve/main/gemma-4-26B-A4B-it-UD-Q5_K_XL.gguf

# ~1.2GB
mkdir -p models/unsloth
curl -L -o models/unsloth/mmproj-BF16.gguf \
  https://huggingface.co/unsloth/gemma-4-26B-A4B-it-GGUF/resolve/main/mmproj-BF16.gguf

# ~21GB
mkdir -p models/unsloth
curl -L -o models/unsloth/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf \
  https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
