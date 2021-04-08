# <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/namd-logo.png" height="60" width="300"> Runbook

## Deployment via web console

### Table of Contents
- [Deployment via web console](#deployment-via-web-console)
  - [Log In](#log-in)
  - [Virtual Cloud Network](#virtual-cloud-network)
  - [Compute Instance](#compute-instance)
  - [Block Storage](#block-storage)
  - [Mounting a Block Storage or NVME SSD Drive](#mounting-a-block-storage-or-nvme-ssd-drive)
  - [Adding a Visualization Node](#adding-a-visualization-node)
  - [Creating a Network File System](#creating-a-network-file-system)
  - [Set up a VNC](#set-up-a-vnc)
  - [Accessing a VNC](#accessing-a-vnc)
- [NAMD Installation](#namd-installation)
  - [Configuring NVIDIA GPUs](#configuring-nvidia-gpus)
  - [Installing NAMD](#installing-namd)

### Log In
You can start by logging in the Oracle Cloud console. If this is the first time, instructions to do so are available [here](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/signingin.htm).
Select the region in which you wish to create your instance. Click on the current region in the top right dropdown list to select another one. 

<img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/Region.png" height="50">

### Virtual Cloud Network
Before creating an instance, we need to configure a Virtual Cloud Network. 
 1. Select the menu <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/menu.png" height="20"> on the top left, then select Networking --> Virtual Cloud Networks. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/create_vcn.png" height="20">.

 2. On the next page, select the following: 
    * Name of your VCN
    * Compartment of your VCN
    * Choose "CREATE VIRTUAL CLOUD NETWORK"

 3. Scroll all the way down and <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/create_vcn.png" height="20">.

 4. Following creation of the VCN, configure a public subnet, an internet gateway, a security list and route table, per the below instructions:
    * [Subnets](https://docs.cloud.oracle.com/en-us/iaas/Content/Network/Tasks/managingVCNs.htm?Highlight=subnet)
    * [Security Lists](https://docs.cloud.oracle.com/en-us/iaas/Content/Network/Concepts/securitylists.htm?Highlight=security%20lists)
    * [Internet Gateway](https://docs.cloud.oracle.com/en-us/iaas/Content/Network/Tasks/managingIGs.htm?Highlight=internet%20gateway)
    * [Route Tables](https://docs.cloud.oracle.com/en-us/iaas/Content/Network/Tasks/managingroutetables.htm)


### Compute Instance

 1. Create a new instance by selecting the menu <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/menu.png" height="20"> on the top left, then select Compute --> Instances. 

    <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/Instances.png" height="300">

 2. On the next page, select <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/create_instance.png" height="25">.

 3. On the next page, select the following:
    * Name of your instance.
    * Availability Domain: Each region has one or more availability domains. Some instance shapes are only available in certain AD.
    * Image: Change the image source to CentOS 7 or Oracle Linux 7.6  (Oracle Linux is recommended).
    * Instance Type: Select Bare Metal
    * Instance Shape: 
      * For 8 V100 GPU, select BM.GPU3.8
      * For 2 P100 GPU, select BM.GPU2.2
      * For CPUs, select BM.HPC2.36
      * Other shapes are available as well, [click for more information](https://cloud.oracle.com/compute/bare-metal/features).
    * SSH key: Attach your public key file. For more information, click [here](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/creatingkeys.htm).
    * Virtual Cloud Network: Select the network that you previously created.

 4. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/create.png" height="25">.

 5. After a few minutes, the instances will turn green, meaning it is up and running. Click on the instance name in the console to identify the public IP. You can now connect using `ssh opc@xx.xx.xx.xx` from the machine using the key that was provided during the creation. 

**If you are using Oracle Linux 7.6 on a machine with GPU's, during instance definition, select the advanced options at the bottom-->select image. Ensure the image specified is the one that contains GPU in its name. That will remove the need to install any driver.**


### Block Storage

**If you are running an HPC shape to run NAMD on CPUs, you can skip this part as you already have local NVME SSD storage on your machine. Skip to the [Mounting a Block Storage or NVME SSD Drive](#mounting-a-block-storage-or-nvme-ssd-drive) because you will still need to mount it.**

 1. Create a new Block Volume by selecting the menu <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/menu.png" height="20"> on the top left, then select Block Storage --> Block Volumes.

 2. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/create_bv.png" height="25">.

 3. On the next page, select the following: 
     * Name
     * Compartment
     * Size (in GB)
     * Availability Domain: Make sure to select the same as your Compute Instance. 

 4. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/create_bv.png" height="25">.

 5. Select the menu <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/menu.png" height="20"> on the top left, then select Compute and Instances.

 6. Click on the instance to which the drive will be attached.

 7. On the lower left, in the Resources menu, click on "Attached Block Volumes".

    <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/resources.png" height="200">

 8. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/attach_BV.png" height="25">

 9. All the default settings will work fine. Select the Block Volume that was just created and specify /dev/oracleoci/oraclevdb as device path. 
  Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/attach.png" height="25">.

    **Note: If you do not see the Block Volume, it may be because you did not place it in the same AD as your running instance**

 10. Once it is attached, hit the 3 dots at the far right of the Block Volume description and select "iSCSi Commands and Information". 

     <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/ISCSi.png" height="150">

 11. Copy and execute the commands to attach the block volume to the instance. 

     <img src="https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/images/iscsi_commands.png" height="200">


### Mounting a Block Storage or NVME SSD Drive

If you have local NVMe storage or if you have attached a block storage to your instance (previous section), you will need to mount it to your running instance to be able to use it. 

 1. After logging in using ssh, run the command `lsblk`. 
The drive should be listed with the NAME on the left (Probably sdb for block and nvme0n1 for local storage, refered to as DNAME in the next commands.

 2. Format the drive:
    ```
    sudo mkfs -t ext4 /dev/DNAME
    ```

 3. Create a directory and mount the drive to it.
    ```
    sudo mkdir /mnt/disk1
    sudo mount /dev/DNAME /mnt/disk1
    sudo chmod 777 /mnt/disk1
    ```


### Adding a Visualization Node

If you want to view and perform post-processing on a separate node than the main compute node, you need to create a new instance. 

 1. Create a new instance by selecting the menu <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/menu.png" height="20"> then Compute --> Instances. 

    <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/Instances.png" height="300">

 2. On the next page, select <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/create_instance.png" height="25">

 3. On the next page, select the following:
    * Name of your instance.
    * Availability Domain: Each region has one or more availability domains. Some instance shapes are only available in certain AD's.
    * Image: Change the image source to CentOS 7 or Oracle Linux 7.6  (Oracle Linux is recommended).
    * Instance Type: Select Bare metal for BM.GPU2.2 or Virtual Machine for VM.GPU2.1.
    * Instance Shape: 
      * BM.GPU2.2
      * VM.GPU2.1
      * BM.GPU3.8
      * VM.GPU3.*
      * Other shapes are available as well, [click for more information](https://cloud.oracle.com/compute/bare-metal/features).
    * SSH key: Attach your public key file. [For more information](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/creatingkeys.htm).
    * Virtual Cloud Network: Select the network that you have previously created.

 4. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/create_instance.png" height="20">

 5. After a few minutes, the instances will turn green, meaning it is up and running. Click on the instance name in the console to identify the public IP. You can now connect using `ssh opc@xx.xx.xx.xx` from the machine using the key that was provided during the creation. 


### Creating a Network File System

If you create a separate compute instance for visualization or post processing than your main compute node, you should create a file system and share the drive between the machines. 

#### Main Compute Node
Since the main compute node is in a public subnet, we will keep the firewall up and add an exception:
```
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --reload
```
We will also activate the nfs-server:

```
sudo yum -y install nfs-utils
sudo systemctl enable nfs-server.service
sudo systemctl start nfs-server.service
```

Edit the file /etc/exports with vim or your favorite text editor. `sudo vi /etc/exports` and add the line `/mnt/share 10.0.0.0/16(rw)`

To activate those changes:

```
sudo exportfs -a
```

#### Visualization Node
In the visualization node, we will also install nfs-utils tools and mount the drive. You will need to grab the private IP address of the visualization node. You can find it in the instance details of the console. It will probably be something like 10.0.0.2, 10.0.1.2 or 10.0.2.2, depending on the CIDR block of the public subnet. Mount the shared drive, as shown below:

```
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --reload
sudo yum -y install nfs-utils
sudo mkdir /mnt/share
sudo mount <visualization node private IP address>:/mnt/share /mnt/share
```


### Set up a VNC
If you used terraform to create the cluster, this step has been done already for the GPU instance.

By default, the only access to the machines is through SSH. If you want to see the NAMD interface, you will need to set up a VNC connection. The following script will work for the default user opc. The password for the vnc session is set as "password" but it can be edited in the next commands. 

```
sudo yum -y groupinstall "Server with GUI"
sudo yum -y install tigervnc-server mesa-libGL
sudo systemctl set-default graphical.target
sudo cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:0.service
sudo sed -i 's/<USER>/opc/g' /etc/systemd/system/vncserver@:0.service
sudo mkdir /home/opc/.vnc/
sudo chown opc:opc /home/opc/.vnc
echo "password" | vncpasswd -f > /home/opc/.vnc/passwd
chown opc:opc /home/opc/.vnc/passwd
chmod 600 /home/opc/.vnc/passwd
sudo systemctl start vncserver@:0.service
sudo systemctl enable vncserver@:0.service
```

### Accessing a VNC
To connect to VNC via SSH tunnel, refer to the [README Post Processing](https://github.com/oci-hpc/oci-hpc-runbook-namd/blob/master/README.md#post-processing) section. 

If you would rather connect without a SSH tunnel, you will need to open ports 5900 and 5901 on the Linux machine both in the firewall and in the security list, as follows: 
 1. Run the following command:
   ```
   sudo firewall-offline-cmd --zone=public --add-port=5900-5901/tcp
   ```
  2. Select the menu <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/menu.png" height="20"> on the top left, then select Networking --> Virtual Cloud Networks. <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/create_vcn.png" height="20">

 3. Select the VCN that you created. Select the Subnet in which the machine reside, probably your public subnet. Select the security list. 

 4. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/addIngress.png" height="20">  
    * CIDR : 0.0.0.0/0
    * IP PROTOCOL: TCP
    * Source Port Range: All
    * Destination Port Range: 5900-5901

 5. Click <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/blob/master/images/addIngress.png" height="20">.

 6. Now you should be able to VNC to the address: ip.add.re.ss:5900. Once you accessed your VNC session, you should go into Applications --> System Tools --> Settings.  

    <img src="https://github.com/oci-hpc/oci-hpc-runbook-shared/raw/master/images/CentOSSeetings.jpg" height="100"> 

 7. In the power options, set the Blank screen timeout to "Never". If you do get locked out of your user session, you can ssh to the instance and set a password for the opc user. 
    ```
    sudo passwd opc
    ```

## NAMD Installation
This guide will show the different steps for the Oracle Linux 7.6 and CentOS 7 images available on Oracle Cloud Infrastructure. 
There is no need to configure NVIDIA GPUs if you have selected an Oracle LINUX version for GPU.

### Configuring NVIDIA GPUs
If you are running NAMD on CPUs this part is not needed, you can skip directly to the part "Installing NAMD".
By default, the nouveau open-source drivers are active. In order to install the Nvidia drivers, they need to be stopped. You can run the following script and reboot your machine. 
```
sudo yum -y install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
sudo sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="modprobe.blacklist=nouveau /g' /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
sudo reboot
```
Once your machine has rebooted, you can run the command `lsmod | grep nouveau` and you should not see any results. 
```
sudo yum -y install kernel-devel-$(uname -r) kernel-headers-$(uname -r) gcc make redhat-lsb-core
wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run
sudo chmod +x cuda_10.1.105_418.39_linux.run
sudo ./cuda_10.1.105_418.39_linux.run --silent
```

### Installing NAMD
If you are using CentOS, install the following library:
```sudo yum -y install mesa-libGLU-devel mesa-libGL-devel```.

You can download NAMD, example models, and the VMD visualizer onto the instance using wget from [here](http://www.ks.uiuc.edu/Research/namd/2.13/notes.html).
