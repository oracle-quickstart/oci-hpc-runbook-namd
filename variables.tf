## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "region" {}
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "availablity_domain_name" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "Subnet-CIDR" {
  default = "10.0.0.0/24"
}

variable "gpu_node_count" {
    default = "1"
}
variable "vnc_password" {
    default = "HPC_oci1"
}

variable "gpu_shape" { 
    default = "BM.GPU2.2"
}

# Possible values are none, vnc or x11vnc
# If x11vnc is selected and NVIDIA drivers are not available, vnc will be used.
variable "gpu_vnc" { 
    default = "vnc"
}

# Install Block NFS, value are 0 or 1
variable "block_nfs" {
  default = "True"
}

# Size in GB
variable "size_block_volume" {
  default = "500"
}

variable "model_drive" {
  default = "block"
}

variable "devicePath" {
  default = "/dev/oracleoci/oraclevdb"
}


variable "namd_url" { 
    default = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/3YWzx8pwApyEYHigvRLFdLNlTlOwzp1hBeXwompHxfI/n/hpc/b/HPC_APPS/o/NAMD_2.13_Linux-x86_64-multicore-CUDA.tar"
}

variable "model_url" { 
    default = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/dtQofvnX4K4BOHfVGuq8oCdtJFt4lP0UXkod1BIQBYk/n/hpc/b/HPC_APPS/o/NAMD_models.tar"
}

variable "vmd_url" { 
    default = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/bpR0VM0GaNlc4yQsGLwO4lZwneKxXwN8vUdtyKcVZcE/n/hpc/b/HPC_APPS/o/vmd-1.9.3.bin.LINUXAMD64-CUDA8-OptiX4-OSPRay111p1.opengl.tar.gz"
}