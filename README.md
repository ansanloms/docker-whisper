# docker-whisper

Run a whisper.cpp HTTP server with Docker and NVIDIA GPU.

## Prerequisites

- NVIDIA GPU + driver
- Docker + NVIDIA Container Toolkit
- `docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi` must work

## Setup

```sh
# Start with defaults (medium, v1.8.3). Model is downloaded automatically on first run.
docker compose up -d --build

# Start with a specific model
WHISPER_MODEL=large-v3 docker compose up -d

# Build with a specific whisper.cpp version
WHISPER_CPP_VERSION=1.8.3 docker compose up -d --build
```

Available models: `tiny`, `base`, `small`, `medium`, `large-v3`

Models are downloaded to `./models/` and persisted. Switching models does not require rebuilding the image — just change the environment variable and restart.

## API

```
POST http://localhost:8178/inference
Content-Type: multipart/form-data
```

Parameters:
- `file`: audio file (wav, mp3, etc.)
- `response_format`: `json` / `text`

Example:

```sh
curl -X POST http://localhost:8178/inference \
  -F "file=@test.mp3" \
  -F "response_format=json"
```
