#!/bin/bash
sudo docker start -i sdnext-ipex $@ || ./build-sdnext-ipex.sh $@
