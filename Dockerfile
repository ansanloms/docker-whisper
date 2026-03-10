FROM nvidia/cuda:12.6.0-devel-ubuntu24.04 AS build

ARG WHISPER_CPP_VERSION=1.8.3

RUN <<EOF
apt-get update
apt-get install -y cmake g++ curl
rm -rf /var/lib/apt/lists/*
EOF

WORKDIR /app

RUN <<EOF
curl -L -o whisper.cpp.tar.gz "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v${WHISPER_CPP_VERSION}.tar.gz"
tar xf whisper.cpp.tar.gz --strip-components=1
rm whisper.cpp.tar.gz

ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

cmake -B build \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES="86" \
  -DCMAKE_EXE_LINKER_FLAGS="-L/usr/local/cuda/lib64/stubs" \
  -DCMAKE_SHARED_LINKER_FLAGS="-L/usr/local/cuda/lib64/stubs"
cmake --build build -j$(nproc)
EOF

FROM nvidia/cuda:12.6.0-runtime-ubuntu24.04

RUN <<EOF
apt-get update
apt-get install -y curl ffmpeg
rm -rf /var/lib/apt/lists/*
EOF

COPY --from=build /app/build/bin/whisper-server /usr/local/bin/whisper-server
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV WHISPER_MODEL=medium
ENV WHISPER_PORT=8178

EXPOSE ${WHISPER_PORT}

ENTRYPOINT ["/entrypoint.sh"]
