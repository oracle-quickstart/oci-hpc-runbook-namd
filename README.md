# <img src="https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/images/namd-logo.png" height="60" width="300"> oci-hpc-runbook-namd

# Introduction
This Runbook provides the steps to deploy a GPU machine on Oracle Cloud Infrastructure, install NAMD, and run a model using NAMD software.  

NAMD is a molecular dynamics software that simulates the movements of atoms in biomolecules under a predefined set of conditions.  It is used to identify the behavior of these biomolecules when exposed to changes in temperature, pressure and other inputs that mimic the actual conditions encountered in a living organism.  NAMD can be used to establish patterns in protein folding, protein-ligand binding, and cell membrane transport, making it a very useful application for drug research and discovery.

NAMD is built on Charm++ and Converse, and can run on high performance computers to execute parallel processing. It was developed by the University of Illinois. More information can be found [here](http://charm.cs.illinois.edu/research/moldyn).

<img align="center" src="https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/images/1bh5_protein_animated.gif" height="180" > 

# Architecture
The architecture for this runbook is simple, a single machine running inside of an OCI VCN with a public subnet.  
Since a GPU instance is used, block storage is attached to the instance and installed with the NAMD application. 
The instance is located in a public subnet and assigned a public ip, which can be accessed via ssh.

For details of the architecture, see [_Deploy molecular dynamics and NAMD applications_](https://docs.oracle.com/en/solutions/deploy-namd-on-oci/index.html)

## Architecture Diagram

![](./images/GPU_arch_draft.png)

# Login
Login to the using opc as a username:
```
   ssh {username}\@{bm-public-ip-address} -i id_rsa
```
Note that if you are using resource manager, obtain the private key from the output and save on your local machine. 

# Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`, `subnets`, and `instances`.

- Quota to create the following resources: 1 VCN, 1 subnet, 1 Internet Gateway, 1 route rules, and 1 GPU (VM/BM) compute instance.

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

# Deployment
Deploying this architecture on OCI can be done in different ways:

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-quickstart/oci-hpc-runbook-namd/releases/latest/download/oci-hpc-runbook-namd-stack-latest.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Deploy Using the Terraform CLI

### Clone the Module
Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/oracle-quickstart/oci-hpc-runbook-namd.git
    cd oci-hpc-runbook-namd
    ls

### Set Up and Configure Terraform

1. Complete the prerequisites described [here](https://github.com/cloud-partners/oci-prerequisites).

2. Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
targetCompartment = "<compartment_ocid>"

# Availability Domain
ad = "<availablity_domain_name>" # for example GrCH:US-ASHBURN-AD-1
bastion_ad = "kWVD:AP-OSAKA-1-AD-1"

# Other variables
ssh_key                  = "<private_ssh_key>"
bastion_boot_volume_size = 150
bastion_shape            = "VM.Standard.E3.Flex"
instance_pool_shape      = "BM.GPU3.8" 
boot_volume_size         = 100
node_count               = 2
use_custom_name          = false
use_existing_vcn         = false
use_marketplace_image    = false 
use_standard_image       = true
cluster_network          = true # only if instance_pool_shape=BM.GPU3.8


````
### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## Deploy Using OCI Console

The [OCI Console](https://github.com/oracle-quickstart/oci-hpc-runbook-namd/blob/main/Documentation/ManualDeployment.md) let you create each piece of the architecture one by one from a webbrowser. This can be used to avoid any terraform scripting or using existing templates. 

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
