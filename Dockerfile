# syntax=docker/dockerfile:1.6

ARG NODE_VERSION=20
ARG CUDA_IMAGE=nvidia/cuda:11.8.0-devel-ubuntu22.04

FROM node:${NODE_VERSION} AS frontend-build
WORKDIR /workspace/frontend
COPY frontend/package.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM node:${NODE_VERSION}-slim AS frontend
WORKDIR /app
ENV NODE_ENV=production
RUN npm install --global serve@14.2.4
COPY --from=frontend-build /workspace/frontend/dist ./dist
EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000", "--single"]

FROM ${CUDA_IMAGE} AS backend-base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-dev python3-distutils python3-pip python3-venv \
    build-essential git curl wget ca-certificates ninja-build pkg-config \
    libgl1 libglib2.0-0 libsm6 libxext6 libxrender1 && \
    rm -rf /var/lib/apt/lists/*
RUN ln -sf /usr/bin/python3 /usr/bin/python && python -m pip install --upgrade pip
WORKDIR /app
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu118 && \
    pip install --no-cache-dir https://github.com/vllm-project/vllm/releases/download/v0.8.5/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl && \
    pip install --no-cache-dir flash-attn==2.7.3 --no-build-isolation && \
    pip install --no-cache-dir modelscope

FROM backend-base AS backend
WORKDIR /app
COPY backend ./backend
RUN printf "MODEL_PATH=/models/DeepSeek-OCR\nDEVICE_ID=0\nMAX_CONCURRENCY=4\n" > .env
RUN useradd --create-home --shell /bin/bash appuser && \
    chown -R appuser:appuser /app
USER appuser
ENV PYTHONUNBUFFERED=1 \
    PATH="/home/appuser/.local/bin:${PATH}" \
    MODEL_PATH=/models/DeepSeek-OCR \
    DEVICE_ID=0 \
    MAX_CONCURRENCY=4
WORKDIR /app/backend
EXPOSE 8002
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8002"]
