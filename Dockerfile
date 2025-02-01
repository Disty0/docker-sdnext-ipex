FROM ubuntu:noble

RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
    software-properties-common \
    build-essential \
    ca-certificates \
    wget \
    gpg \
    git

RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble client" | tee /etc/apt/sources.list.d/intel-gpu-noble.list
RUN apt-get update

RUN apt-get install -y --no-install-recommends --fix-missing \
    intel-opencl-icd=24.39.31294.20-1032~24.04 \
    libze-intel-gpu1=24.39.31294.20-1032~24.04 \
    libze1=1.17.44.0-1022~24.04

RUN apt-get install -y --no-install-recommends --fix-missing \
    libgl1 \
    libglib2.0-0 \
    libgomp1

ENV PYTHON=python3.11
RUN add-apt-repository ppa:deadsnakes/ppa -y && apt-get update
RUN apt-get install -y --no-install-recommends --fix-missing \
    $PYTHON \
    $PYTHON-dev \
    $PYTHON-venv \
    python3-pip

# jemalloc is not required but it is highly recommended (also used with optional ipexrun)
RUN apt-get install -y --no-install-recommends --fix-missing libjemalloc-dev
ENV LD_PRELOAD=libjemalloc.so.2

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo '#!/bin/bash\ngit status || git clone https://github.com/vladmandic/sdnext.git .\n/app/webui.sh "$@"' | tee /bin/startup.sh
RUN chmod 755 /bin/startup.sh

VOLUME [ "/app" ]
VOLUME [ "/mnt/data" ]
VOLUME [ "/mnt/models" ]
VOLUME [ "/mnt/python" ]
VOLUME [ "/root/.cache/huggingface" ]

ENV SD_DOCKER=true
ENV SD_DATADIR="/mnt/data"
ENV SD_MODELSDIR="/mnt/models"
ENV venv_dir="/mnt/python/venv"

WORKDIR /app
ENTRYPOINT [ "startup.sh", "-f", "--use-ipex", "--listen" ]
STOPSIGNAL SIGINT
