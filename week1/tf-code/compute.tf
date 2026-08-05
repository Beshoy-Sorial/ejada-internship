data "oci_core_images" "ol_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "10"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "ejada_instance" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "ejada-instance"
  shape                = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.ejada_public_subnet.id
    display_name     = "ejada-vnic"
    assign_public_ip = true
    hostname_label   = "ejadainstance"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ol_images.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  # Flexible shapes (e.g. VM.Standard.E4.Flex, VM.Standard.A1.Flex) require
  # an explicit shape_config with ocpus/memory. Fixed shapes ignore this block.
  dynamic "shape_config" {
    for_each = length(regexall("Flex", var.instance_shape)) > 0 ? [1] : []
    content {
      ocpus         = var.instance_ocpus
      memory_in_gbs = var.instance_memory_in_gbs
    }
  }
}

resource "oci_core_volume" "ejada_block_volume" {
  compartment_id       = var.compartment_ocid
  availability_domain  = var.availability_domain
  display_name         = "ejada-block-volume"
  size_in_gbs          = 50
}

resource "oci_core_volume_attachment" "ejada_volume_attachment" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.ejada_instance.id
  volume_id       = oci_core_volume.ejada_block_volume.id
  display_name    = "ejada-volume-attachment"
}
