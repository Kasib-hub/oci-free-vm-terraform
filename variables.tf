variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {
  default = "us-phoenix-1" # Change to your preferred region
}
variable "vm_name" {}
variable "vcn_ocid" {}
variable "subnet_ocid" {}
variable "availability_domain" {}
variable "shape" {}
variable "instance_ocpus" { default = 1 }
variable "instance_shape_config_memory_in_gbs" { default = 6 }