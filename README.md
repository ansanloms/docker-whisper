# whisper.cpp Server (Docker + CUDA)

whisper.cpp の HTTP サーバを Docker + NVIDIA GPU で動かす。

## 前提

- NVIDIA GPU + ドライバ
- Docker + NVIDIA Container Toolkit
- `docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi` が動くこと

## セットアップ

```sh
# デフォルト (medium, v1.8.3) で起動。初回はモデルを自動ダウンロード
docker compose up -d --build

# モデルを指定して起動
WHISPER_MODEL=large-v3 docker compose up -d

# whisper.cpp バージョンを指定してビルド
WHISPER_CPP_VERSION=1.8.3 docker compose up -d --build
```

使用可能なモデル: `tiny`, `base`, `small`, `medium`, `large-v3`

モデルは `./models/` にダウンロードされ永続化される。モデル変更時はイメージの再ビルド不要、環境変数を変えて再起動するだけ。

## API

```
POST http://localhost:8178/inference
Content-Type: multipart/form-data
```

パラメータ:
- `file`: 音声ファイル (wav, mp3 等)
- `response_format`: `json` / `text`

例:

```sh
curl -X POST http://localhost:8178/inference \
  -F "file=@test.mp3" \
  -F "response_format=json"
```
