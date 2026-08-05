variable "tenancy_ocid" {
  description = "OCID of your tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the user calling the API"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API signing key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the API signing private key (PEM)"
  type        = string
}

variable "region" {
  description = "OCI region, e.g. me-jeddah-1"
  type        = string
  default     = "me-jeddah-1"
}

variable "compartment_ocid" {
  description = "OCID of the compartment to deploy into"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain name for the instance/volume"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key content for instance access"
  type        = string
}

variable "instance_shape" {
  description = "Compute shape"
  type        = string
  default     = "VM.Standard.E5.Flex"
}

variable "instance_ocpus" {
  description = "OCPU count, only used if instance_shape is a Flex shape"
  type        = number
  default     = 1
}

variable "instance_memory_in_gbs" {
  description = "Memory in GB, only used if instance_shape is a Flex shape"
  type        = number
  default     = 6
}
