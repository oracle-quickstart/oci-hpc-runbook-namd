## Copyright © 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "targetCompartment" {}
variable "ad" {}
variable "ssh_key" {}
variable "cluster_network" { default = true }
variable "use_custom_name" { default = false}
variable "cluster_name" { default = "" }
variable "bastion_ad" {}
variable "bastion_shape" {}
variable "use_standard_image" {}
variable "custom_bastion_image" {
  type    = string
  default = "image.ocid"
}
variable "bastion_boot_volume_size" {}
variable "cluster_network_shape" { default = "BM.HPC2.36" }
variable "instance_pool_shape" { default = "BM.GPU3.8" }
variable "node_count" {}
variable "boot_volume_size" {}
variable "use_marketplace_image" { default = false }
variable "image" { default = "ocid1.image.oc1..aaaaaaaa5yxem7wzie34hi5km4qm2t754tsfxrjuefyjivebrxjad4jcj5oa" }
variable "image_ocid" { default = "ocid1.image.oc1..aaaaaaaa5yxem7wzie34hi5km4qm2t754tsfxrjuefyjivebrxjad4jcj5oa" }
variable "unsupported_bastion_image" { default = "" }
variable "use_cluster_nfs" { default = true }
variable "use_scratch_nfs" { default = true }
variable "cluster_nfs_path" { default = "/nfs/cluster" }
variable "scratch_nfs_path" { default = "/nfs/scratch" }
variable "vcn_compartment" { default = "" }
variable "vcn_id" { default = "" }
variable "use_existing_vcn" { default = false }
variable "public_subnet_id" { default = "" }
variable "private_subnet_id" { default = "" }
variable "vcn_subnet" { default = "172.16.0.0/21" }
variable "public_subnet" { default = "172.16.0.0/24" }
variable "additional_subnet" { default = "172.16.1.0/24" }
variable "private_subnet" { default = "172.16.4.0/22" }
variable "ssh_cidr" { default = "0.0.0.0/0" }
#namd
variable "namd" { default = true }
variable "namd_binaries" { default = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/3YWzx8pwApyEYHigvRLFdLNlTlOwzp1hBeXwompHxfI/n/hpc/b/HPC_APPS/o/NAMD_2.13_Linux-x86_64-multicore-CUDA.tar"}
variable "namd_model" { default = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/dtQofvnX4K4BOHfVGuq8oCdtJFt4lP0UXkod1BIQBYk/n/hpc/b/HPC_APPS/o/NAMD_models.tar"}
variable "slurm" { default = false }
variable "ldap" { default = true }
variable "spack" { default = false }
variable "bastion_ocpus" { default = 2 }
variable "instance_pool_ocpus" { default = 2 }
variable "instance_pool_memory" { default = 16 }
variable "instance_pool_custom_memory" { default = false }
variable "bastion_memory" { default = 16 }
variable "bastion_custom_memory" { default = false }
variable "marketplace_listing" {
  default = "1. OL7.9-Gen2-GPU-2021.10.20-0"
}

variable "marketplace_version_id" {
  type = map(string)
  default = {
    "1" = "OL7.9-Gen2-GPU-2021.10.20-0"
  }
}

variable "marketplace_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaahzcnanlki5vonyaeoiajjisejikzczygqqwheifymjqx3ft4iowa"
}

variable "bastion_block_volume_performance" {
  /* 
  Allowed values 
  "0.  Lower performance"
  "10. Balanced performance"
  "20. High Performance"
*/

  default = "10. Balanced performance"

}

variable "bastion_block" {
  default = false
}

variable "bastion_block_volume_size" {
  default = 1000
}
variable "scratch_nfs_type_cluster" { default = "nvme" }
variable "scratch_nfs_type_pool" { default = "none" }
variable "cluster_block_volume_size" { default = "1000" }
variable "cluster_block_volume_performance" { default = "10. Balanced performance" }

variable "inst_prin" { default = true }
variable "api_user_key" { default = "None" }
variable "api_fingerprint" { default = "None" }
variable "api_user_ocid" { default = "None" }
variable "home_nfs" { default = true }
variable "configure" { default = true }

variable "hyperthreading" { default = true }

variable "autoscaling" { default = false }
variable "add_nfs" { default = false }
variable "create_ffs" { default = false }
variable "fss_compartment" { default = "" }
variable "fss_ad" { default = "" }
variable "nfs_target_path" { default = "/app" }
variable "nfs_source_IP" { default = "" }
variable "nfs_source_path" { default = "/app" }
variable "nfs_options" { default = "" }
variable "monitoring" { default = true }

variable "unsupported" {
  type    = bool
  default = false
}

variable "unsupported_bastion" {
  type    = bool
  default = false
}

variable "bastion_username" {
  type    = string
  default = "opc"
}

variable "compute_username" {
  type    = string
  default = "opc"
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.2"
}
