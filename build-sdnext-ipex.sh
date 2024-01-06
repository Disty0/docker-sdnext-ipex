#!/bin/bash

if [[ -z "${SDNEXT_DOCKER_ROOT_FOLDER}" ]]
then
    SDNEXT_DOCKER_ROOT_FOLDER="~/sdnext"
fi

sudo docker stop sdnext-ipex
sudo docker rm sdnext-ipex

sudo docker run -it --device /dev/dri -v $SDNEXT_DOCKER_ROOT_FOLDER/git:/sdnext -v $SDNEXT_DOCKER_ROOT_FOLDER/python:/python -v $SDNEXT_DOCKER_ROOT_FOLDER/huggingface:/root/.cache/huggingface -p 7860:7860 -e DISABLE_IPEXRUN=$DISABLE_IPEXRUN --name sdnext-ipex sdnext-ipex $@ || \
(sudo docker build -t sdnext-ipex -f Dockerfile . && \
sudo docker run -it --device /dev/dri -v $SDNEXT_DOCKER_ROOT_FOLDER/git:/sdnext -v $SDNEXT_DOCKER_ROOT_FOLDER/python:/python -v $SDNEXT_DOCKER_ROOT_FOLDER/huggingface:/root/.cache/huggingface -p 7860:7860 -e DISABLE_IPEXRUN=$DISABLE_IPEXRUN --name sdnext-ipex sdnext-ipex $@)
