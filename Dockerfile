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

RUN add-apt-repository ppa:deadsnakes/ppa -y && apt-get update
RUN apt-get install -y --no-install-recommends --fix-missing \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3-pip

RUN apt-get install -y --no-install-recommends --fix-missing \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    libjemalloc-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/bash\ngit status || git clone https://github.com/vladmandic/automatic.git .\n./webui.sh "$@"' | tee /bin/startup.sh
RUN chmod 755 /bin/startup.sh

VOLUME [ "/python" ]
VOLUME [ "/sdnext" ]
VOLUME [ "/root/.cache/huggingface" ]

ENV LD_PRELOAD=libjemalloc.so.2

ENV SD_DOCKER=true
ENV PYTHON=python3.10
ENV venv_dir=/python/venv

WORKDIR /sdnext
 
ENTRYPOINT [ "startup.sh", "-f", "--use-ipex", "--listen" ]
