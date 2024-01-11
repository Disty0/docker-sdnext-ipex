FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
    ca-certificates \
    wget \
    gpg \
    git

RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
    gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client" | \
    tee /etc/apt/sources.list.d/intel-gpu-jammy.list
RUN apt-get update

RUN apt-get install -y --no-install-recommends --fix-missing \
    intel-opencl-icd=23.35.27191.42-775~22.04 \
    intel-level-zero-gpu=1.3.27191.42-775~22.04 \
    level-zero=1.14.0-744~22.04

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
    python3.10 \
    python3-pip \
    python3-venv

RUN pip --no-cache-dir install --upgrade \
    pip \
    setuptools

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

ENV venv_dir=/python/venv
WORKDIR /sdnext
 
ENTRYPOINT [ "startup.sh", "-f", "--use-ipex", "--listen" ]
