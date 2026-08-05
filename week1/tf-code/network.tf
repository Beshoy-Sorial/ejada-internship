resource "oci_core_vcn" "ejada_vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "ejada-vcn"
  dns_label      = "ejadavcn"
}

resource "oci_core_internet_gateway" "ejada_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ejada_vcn.id
  display_name   = "ejada-igw"
  enabled        = true
}

resource "oci_core_route_table" "ejada_public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ejada_vcn.id
  display_name   = "ejada-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ejada_igw.id
  }
}

resource "oci_core_security_list" "ejada_public_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ejada_vcn.id
  display_name   = "ejada-public-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # ICMP: path MTU discovery from anywhere (fragmentation needed / don't fragment)
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
    icmp_options {
      type = 3
      code = 4
    }
  }

  # ICMP: destination unreachable within the VCN
  ingress_security_rules {
    protocol = "1"
    source   = "10.0.0.0/16"
    icmp_options {
      type = 3
    }
  }

  # NFS: portmapper
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/16"
    tcp_options {
      min = 111
      max = 111
    }
  }

  ingress_security_rules {
    protocol = "17" # UDP
    source   = "10.0.0.0/16"
    udp_options {
      min = 111
      max = 111
    }
  }

  # NFS: nfsd
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16"
    tcp_options {
      min = 2049
      max = 2049
    }
  }

  # NFS: statd
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16"
    tcp_options {
      min = 2048
      max = 2048
    }
  }

  ingress_security_rules {
    protocol = "17"
    source   = "10.0.0.0/16"
    udp_options {
      min = 2048
      max = 2048
    }
  }

  # NFS: mountd / nlockmgr
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/16"
    tcp_options {
      min = 2050
      max = 2050
    }
  }
}

resource "oci_core_subnet" "ejada_public_subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.ejada_vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "ejada-public-subnet"
  dns_label                  = "public"
  route_table_id              = oci_core_route_table.ejada_public_rt.id
  security_list_ids           = [oci_core_security_list.ejada_public_sl.id]
  prohibit_public_ip_on_vnic  = false
}
