# AI Local LLM Setup

A self-hosted, Docker Compose-based setup for running local large language models with a web UI, web search, and terminal access.

## Architecture

| Service | Port | Description |
|---------|------|-------------|
| llama.cpp | 8082 | Local LLM inference server (GPU-accelerated via NVIDIA CUDA) |
| Open WebUI | 3000 | Chat interface (Open WebUI) |
| SearXNG | 8083 | Private, metasearch engine for web search |

## Prerequisites

- Docker & Docker Compose
- NVIDIA GPU with CUDA support and [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- ~41 GB free disk space for models

## Quick Start

1. **Clone and configure**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` to select your model.

2. **Download models**
   ```bash
   chmod +x download_models.sh
   ./download_models.sh
   ```
   Models will be placed in the `models/` directory.

3. **Start services**
   ```bash
   docker compose up -d
   ```

4. **Open** [http://localhost:3000](http://localhost:3000) to start chatting.

## Model Selection

Edit `.env` to choose a model. All models were tested in WSL2 within a Docker container (results may be better on bare metal):

| Option | Quantization | Speed (4070 Ti 12GB) | Use Case |
|--------|-------------|----------------------|----------|
| Option 1 | Q5_K_XL (~20 GB) | ~15 tok/s | Best quality, logic-heavy tasks |
| Option 2 | Q3_K_M (~12 GB) | ~33 tok/s | Fastest, casual use |
| Option 3 | Q4_K_M (~15 GB) | ~20 tok/s | Balanced quality and speed |
| Option 4 | Q4_K_M (~15 GB) | ~20 tok/s | Best quality |

The default model is **Qwen3.6-35B-A3B (Q4_K_M)**.

### Supported model types

The `MODEL_TYPE` variable in `.env` controls inference parameters:

- `gemma` — Gemma models with fit-context optimization
- `gemma-vision` — Gemma vision models with multimodal support (requires `VISION_MODEL`)
- `deepseek` — DeepSeek models with GPU layer offloading
- `qwen` — Qwen models with MoE optimization and KV cache quantization

## Configuration

### llama.cpp (`docker-compose.yaml`)

Key settings:
- `--ctx-size 32768` — Context window size
- `--flash-attn on` — Flash attention enabled
- `--mlock` — Memory lock for performance
- `--jinja` — Jinja2 template support

### Open WebUI

Configured to connect to the local llama.cpp server via `OPENAI_API_BASE_URL`. No API key is required.

### SearXNG

Settings live in `searxng/settings.yml`. SearXNG provides privacy-respecting web search results that can be integrated with the chat interface.

## Directory Structure

```
.
├── docker-compose.yaml   # Service definitions
├── .env.example          # Environment variable template
├── .env                  # Your configuration (gitignored)
├── download_models.sh    # Model download script
├── models/               # Place .gguf model files here
├── open-webui/           # Open WebUI data (uploads, cache, DB)
└── searxng/              # SearXNG settings
```

## Troubleshooting

- **GPU not detected**: Ensure `nvidia-container-toolkit` is installed and `docker info | grep -i nvidia` shows the NVIDIA runtime.
- **Out of VRAM**: Switch to a lower quantization (Q3 or Q4) or reduce `--n-gpu-layers`.
- **Slow inference**: Verify `--flash-attn on` is set and check that CUDA is active in the llama.cpp logs.
