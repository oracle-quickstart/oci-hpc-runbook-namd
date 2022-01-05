# set environment variables for GPU deployment - template


export TF_VAR_user_ocid="<USER_OCID>"
export TF_VAR_fingerprint="<FINGERPRINT>"
export TF_VAR_tenancy_ocid="<TENANCY OCID>"
export TF_VAR_region="<REGION IDENTIFIER>"
export TF_VAR_targetCompartment="COMPARTMENT OCID"
export TF_VAR_vcn_subnet=172.16.0.0/21
export TF_VAR_public_subnet=172.16.0.0/24
export TF_VAR_private_subnet=172.16.1.0/24
export TF_VAR_ad="<AVAILABILITY DOMAIN NAME - CLUSTER NODE>"
export TF_VAR_bastion_ad="<AVAILABILITY DOMAIN NAME - BASTION NODE>"
export TF_VAR_ssh_key=$(cat ~/.ssh/id_rsa.pub)
export TF_VAR_bastion_boot_volume_size=50
export TF_VAR_bastion_shape="VM.Standard2.1"
export TF_VAR_boot_volume_size=50
export TF_VAR_node_count=1
export TF_VAR_use_marketplace_image=false
export TF_VAR_use_standard_image=true
export TF_VAR_image="<GPU IMAGE OCID>" # ocid1.image.oc1.iad.aaaaaaaauxiojmykhmae3xcz4c6k2gmbvs6im5mfjg2zsigsvkwpoquhdvja
export TF_VAR_instance_pool_shape="BM.GPU3.8"
export TF_VAR_cluster_network=false

# set   TF_VAR_ variables: $ source env.sh
# unset TF_VAR_ variables: $ unset ${!TF_VAR_@}


