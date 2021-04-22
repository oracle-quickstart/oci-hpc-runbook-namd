# <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/images/namd-logo.png" height="60" width="300"> Runbook

## Introduction
This Runbook provides the steps to deploy a GPU machine on Oracle Cloud Infrastructure, install NAMD, and run a model using NAMD software.  

NAMD is a molecular dynamics software that simulates the movements of atoms in biomolecules under a predefined set of conditions.  It is used to identify the behavior of these biomolecules when exposed to changes in temperature, pressure and other inputs that mimic the actual conditions encountered in a living organism.  NAMD can be used to establish patterns in protein folding, protein-ligand binding, and cell membrane transport, making it a very useful application for drug research and discovery.

NAMD is built on Charm++ and Converse, and can run on high performance computers to execute parallel processing. It was developed by the University of Illinois. More information can be found [here](http://charm.cs.illinois.edu/research/moldyn).

<img align="center" src="https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/images/1bh5_protein_animated.gif" height="180" > 

## Architecture
The architecture for this runbook is simple, a single machine running inside of an OCI VCN with a public subnet.  
Since a GPU instance is used, block storage is attached to the instance and installed with the NAMD application. 
The instance is located in a public subnet and assigned a public ip, which can be accessed via ssh.
<img src="https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/images/GPU_arch_draft.png" height ="550" width="1200">

## Login
Login to the using opc as a username:
```
   ssh {username}\@{bm-public-ip-address} -i id_rsa
```
Note that if you are using resource manager, obtain the private key from the output and save on your local machine. 

## Deployment

Deploying this architecture on OCI can be done in different ways:
* The [resource Manager](https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/Documentation/ResourceManager.md) let you deploy the infrastructure from the console. Only relevant variables are shown but others can be changed in the zip file. 
* The [web console](https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/Documentation/ManualDeployment.md) let you create each piece of the architecture one by one from a webbrowser. This can be used to avoid any terraform scripting or using existing templates. 

## Licensing
See [Third Party Licenses](https://github.com/oracle-quickstart/oci-hpc-runbook-namd/tree/main/Third_Party_Licenses) for NAMD and terraform licensing, including dependencies used in this tutorial.

## Running the Application
If the provided terraform scripts are used to launch the application, NAMD with CUDA is installed in the /mnt/block/NAMD/NAMD_2.13_CUDA folder and two example models are available in /mnt/block/work/NAMD_models folder. 

1. Run NAMD with CUDA via the following command:
   ```
    namd2 +p<# of cores> +setcpuaffinity +devices <cuda visible devices> +idlepoll +commap <CPU to GPU mapping> <model path> > output.txt
   ```
   where:
     * +p - number of CPU cores
     * +setcpuaffinity - assign threads/processes in a round-robin fashion to available cores in the order they are numbered by the operating system
     * +devices - number of GPU devices
     * +idlepoll - poll the GPU for results rather than sleeping while idle
     * +commap - communication mapping of the CPU’s with GPU’s
     * output.txt - output file with the analysis

   Example for BM.GPU2.2:
   ```
    namd2 +p26 +devices 0,1 +idlepoll +commap 0,14 /mnt/block/work/NAMD_models/apoa1/apoa1.namd > output.txt
   ```

   Example for BM.GPU3.8:
   ```
    namd2 +p52 +devices 0,1,2,3,4,5,6,7 +commap 0,1,2,3,26,27,28,29 /mnt/block/work/NAMD_models/apoa1/apoa1.namd > output.txt
   ```

2. Run ns_per_day.py against the output file to calculate nanoseconds per day averaged over the logged Timing statements. This is used to identify the performance and efficiency of the application using the current CPU/GPU configuration.
   ```
   ns_per_day.py output.txt
   ```
## Post-processing

For post-processsing, you can use Visual Molecular Dynamics (VMD) software to analyze the models.
Run the following commands to configure VMD:
```
./configure
cd src
sudo make install
```

If you are using vnc, launch vncserver and create a vnc password as follows:
```
sudo systemctl start vncserver@:1.service
sudo systemctl enable vncserver@:1.service
vncserver
vncpasswd
```

Start up a vnc connection using localhost:5901 (ensure tunneling is configured), and run the following commands to start up VMD:
```
vmd
```

Open the apoa1 and stmv pdb files in /mnt/block/work/NAMD_models and start playing with your models.
