output "HeadNodePublicIP" {
  value = oci_core_instance.GPU_Instance.*.public_ip
}
output "HeadNodePrivateIP" {
  value = oci_core_instance.GPU_Instance.*.private_ip
}
output "Private_key" {
  value = tls_private_key.key.private_key_pem
}