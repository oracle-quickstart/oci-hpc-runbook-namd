#!/bin/bash -v

echo "gpu-start-app"
echo $*

# Stop the firewall to allow communication with the nodes
# TODO: find the exact ports to open
sudo systemctl stop firewalld


# Add librairies

if [ "$3" != "" ]
then
    echo Installing NAMD
    mkdir /mnt/block/NAMD
    chmod +x /mnt/block/NAMD
    cd /mnt/block/NAMD
    wget -O - $3 | tar xvz
    mv NAMD_2.13_Linux-x86_64-multicore-CUDA NAMD_2.13_CUDA
    chmod +x /mnt/block/NAMD/NAMD_2.13_CUDA
    echo export PATH=/mnt/block/NAMD/NAMD_2.13_CUDA/:\$PATH | sudo tee -a ~/.bashrc
    source ~/.bashrc
fi

if [ "$2" != "" ]
then
    echo Downloading model
    mkdir /mnt/block/work
    chmod +x /mnt/block/work
    cd /mnt/block/work
    wget -O - $2 | tar xvz
    chmod +x /mnt/block/work/NAMD_models
    echo export PATH=/mnt/block/work/NAMD_models/:\$PATH | sudo tee -a ~/.bashrc
    source ~/.bashrc
fi