# Optional: managed NFS file system, matching the Lab 1 file storage step.
resource "oci_file_storage_file_system" "ejada_fs" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "ejada-file-system"
}

resource "oci_file_storage_mount_target" "ejada_mount_target" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  subnet_id           = oci_core_subnet.ejada_public_subnet.id
  display_name        = "ejada-mount-target"
}

resource "oci_file_storage_export" "ejada_export" {
  export_set_id  = oci_file_storage_mount_target.ejada_mount_target.export_set_id
  file_system_id = oci_file_storage_file_system.ejada_fs.id
  path           = "/ejadaexport"
}
