#!/bin/bash

sudo docker stop sdnext-ipex
sudo docker rm sdnext-ipex

sudo docker run -it --device /dev/dri -v ~/sdnext/git:/sdnext -v ~/sdnext/python:/python -v ~/sdnext/huggingface:/root/.cache/huggingface -p 7860:7860 -e DISABLE_IPEXRUN=$DISABLE_IPEXRUN --name sdnext-ipex sdnext-ipex $@ || \
(sudo docker build -t sdnext-ipex -f Dockerfile . && \
sudo docker run -it --device /dev/dri -v ~/sdnext/git:/sdnext -v ~/sdnext/python:/python -v ~/sdnext/huggingface:/root/.cache/huggingface -p 7860:7860 -e DISABLE_IPEXRUN=$DISABLE_IPEXRUN --name sdnext-ipex sdnext-ipex $@)
