FROM nvcr.io/nvidia/pytorch:23.10-py3

COPY . /app/
WORKDIR /app

RUN apt-get update && apt-get install -y \
    iperf \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'source ./.local/bin/env' >> /root/.bashrc

RUN /root/.local/bin/uv venv && \
    . .venv/bin/activate && \
    /root/.local/bin/uv sync --extra all

RUN pip install --no-cache-dir huggingface_hub datasets

ARG HF_TOKEN
RUN huggingface-cli login --token $HF_TOKEN

# docker build --build-arg HF_TOKEN=your_token_here -t prime .
