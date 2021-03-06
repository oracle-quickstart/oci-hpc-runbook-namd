# <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/images/namd-logo.png" height="60" width="300"> Runbook

## Deployment through Resource Manager

### Table of Contents
 - [Log In](#log-in)
 - [Add NAMD Installer to Object Storage](#add-namd-installer-to-object-storage)
 - [Resource Manager](#resource-manager)
 - [Select Variables](#select-variables)
 - [Run the Stack](#run-the-stack)
 - [Access Your GPU Node](#access-your-gpu-node)
  

### Log In
You can start by logging in the Oracle Cloud console. If this is the first time, instructions are available [here](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/signingin.htm).
Select the region in which you wish to create your instance. Click on the current region in the top right dropdown list to select another one. 

<img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/Region.png" height="50">


### Add NAMD Installer to Object Storage
*Note that the terraform scripts [zip file](https://github.com/oracle-quickstart/oci-hpc-runbook-namd/tree/master/Resources/namd-2.13-cuda.zip) provided in this github already contain object storage urls for NAMD 2.13 CUDA, VMD 1.9.3 and example NAMD models (apoa1 & stmv). If you want to change these url's, modify the variable.tf file and replace the values for namd_url, model_url and vmd_url with your own pre-authenticated request urls.*

  1. Select the menu <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/menu.png" height="20"> on the top left, then select Object Storage --> Object Storage.

  2. Create a new bucket or select an existing one. To create one, click on <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/create_bucket.png" height="20">.

  3. Leave the default options: Standard as Storage tiers and Oracle-Managed keys. Click on <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/create_bucket.png" height="20">.

  4. Click on the newly created bucket name and then select <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/upload_object.png" height="20">.

  5. Select your NAMD installer tar file and click <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/upload_object.png" height="20">.

  6. Click on the 3 dots to the right side of the object you just uploaded <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/3dots.png" height="20"> and select "Create Pre-Authenticated Request". 

  6. In the following menu, leave the default options and select an expiration date for the URL of your installer. Click on  <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/pre_auth.png" height="25">.

  7. In the next window, copy the "PRE-AUTHENTICATED REQUEST URL" and keep it. You will not be able to retrieve it after you close this window. If you loose it or it expires, it is always possible to recreate another Pre-Authenticated Request that will generate a different URL.


### Resource Manager
In the OCI console, there is a Resource Manager available that will create all the resources needed. The region in which you create the stack will be the region in which it is deployed.

  1. Select the menu <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/menu.png" height="20"> on the top left, then select Resource Manager --> Stacks. Choose the Name and Compartment on the left filter menu where the stack will be run.

  2. Create a new stack: <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/stack.png" height="20">

  3. Download the [zip file](https://github.com/oracle-quickstart/oci-hpc-runbook-namd/tree/master/Resources/namd-2.13-cuda.zip) for terraform scripts and upload it into the stack. 

Move to the [Select Variables](#select-variables) section to complete configuration of the stack.

### Select variables

Click on <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/next.png" height="20"> and fill in the variables. 

GPU Node:
* SHAPE OF THE GPU COMPUTE NODE: Shape of the Compute Node that will be used to run NAMD. Select bare metal shapes BM.GPU2.2 or BM.GPU3.8 for best performance.
* AVAILABILITY DOMAIN: AD of the Instance and Block Volume. The AD must have available GPU's.
* GPU Node Count: Number of GPU Nodes Required.
* VNC TYPE FOR THE GPU: Visualization Type for the headnode: none, VNC or X11VNC.
* PASSWORD FOR THE VNC SESSIONS: password to use the VNC session on the Pre/Post Node.

Block Options:
* BLOCK VOLUME SIZE ( GB ): Size of the shared block volume.

NAMD:
* URL TO DOWNLOAD NAMD: URL of the installer of NAMD 2.13 CUDA (Leave blank if you wish to download later).
* URL TO DOWNLOAD A MODEL TARBALL: URL of the model you wish to run (Leave blank if you wish to download later).
* URL TO DOWNLOAD VMD: URL to download VMD 1.9.3 to visualize NAMD models (Leave blank if you wish to download later).

Click on <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/next.png" height="20">.
Review the informations and click on <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/create.png" height="20">.

### Run the stack

Now that your stack is created, you can run jobs. 

Select the stack that you created.
In the "Terraform Actions" dropdown menu <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-parabricks/blob/main/images/tf_actions.png" height="20">, run 'Apply' to launch the GPU infrastructure.

### Access your GPU Node

Once your job has completed successfully in Resource Manager, you can find the Public IP Addresses for the GPU node and the Private Key on the lower left menu under **Outputs**. Copy the Private Key onto your local machine, change the permissions of the key and login to the instance:

```
chmod 400 /home/user/key
ssh -i /home/user/key opc@ipaddress
```

Once logged into your GPU node, you can run NAMD from /mnt/block. Refer to the README.md file for specific commands on how to run NAMD on your GPU instance.
