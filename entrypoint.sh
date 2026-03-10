#!/bin/sh
set -e

MODEL_PATH="/app/models/ggml-${WHISPER_MODEL}.bin"

if [ ! -f "$MODEL_PATH" ]; then
  echo "[entrypoint] Model not found: ${MODEL_PATH}"
  echo "[entrypoint] Downloading ggml-${WHISPER_MODEL}.bin ..."
  mkdir -p /app/models
  curl -L -o "$MODEL_PATH" \
    "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${WHISPER_MODEL}.bin"
  echo "[entrypoint] Download complete."
fi

echo "[entrypoint] Starting whisper-server with model: ${WHISPER_MODEL} on port: ${WHISPER_PORT:-8178}"
exec whisper-server \
  -m "$MODEL_PATH" \
  -l ja \
  --host 0.0.0.0 \
  --port "${WHISPER_PORT:-8178}"
