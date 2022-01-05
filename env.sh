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
export TF_VAR_image_name="Oracle-Linux-7.9-Gen2-GPU-2021.12.14-0"
export TF_VAR_image=$(oci --region ${TF_VAR_region} compute image list --compartment-id ${TF_VAR_targetCompartment} --all | jq -r '.data[] | select(."display-name"==env.TF_VAR_image_name).id')
export TF_VAR_instance_pool_shape="BM.GPU3.8"
export TF_VAR_cluster_network=false

# set   TF_VAR_ variables: $ source env.sh
# unset TF_VAR_ variables: $ unset ${!TF_VAR_@}


