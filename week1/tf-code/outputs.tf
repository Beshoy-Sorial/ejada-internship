output "instance_public_ip" {
  value = oci_core_instance.ejada_instance.public_ip
}

output "vcn_id" {
  value = oci_core_vcn.ejada_vcn.id
}

output "public_subnet_id" {
  value = oci_core_subnet.ejada_public_subnet.id
}

output "block_volume_id" {
  value = oci_core_volume.ejada_block_volume.id
}

output "mount_target_export_path" {
  value = "${oci_file_storage_mount_target.ejada_mount_target.id}:${oci_file_storage_export.ejada_export.path}"
}
