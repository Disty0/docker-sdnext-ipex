# docker-sdnext-ipex
Docker image file for SD.Next with Intel ARC GPUs  

Install and run with a single command:  
```
git clone https://github.com/Disty0/docker-sdnext-ipex.git && cd docker-sdnext-ipex && ./run-sdnext-ipex.sh
```  

You can use the scripts in this repo after the first run.  
```
./run-sdnext-ipex.sh
```  

Or you can run it with docker:  
```
sudo docker start -i sdnext-ipex
```


# Environment variables:
Use `SDNEXT_DOCKER_ROOT_FOLDER` if you want to specify a folder for the SDNext files.  
Use `IPEXRUN=True` to use ipexrun.  
