
data "oci_core_vcn" "this" {
  vcn_id = var.vcn_ocid
}

data "oci_core_subnet" "this" {
  subnet_id = var.subnet_ocid
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.tenancy_ocid
  display_name   = "testIG"
  vcn_id         = data.oci_core_vcn.this.id
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id         = data.oci_core_vcn.this.id
  display_name   = "testRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_instance" "free_tier_instance" {
  compartment_id      = var.tenancy_ocid
  availability_domain = var.availability_domain
  shape               = var.shape # Free Tier eligible shape
  display_name        = var.vm_name

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.free_tier_images.images[0].id
  }

  shape_config {
    ocpus = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id = data.oci_core_subnet.this.id
    assign_public_ip = true
  }

  // Has to be an rsa key with no BEGIN or END tag
  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "free_tier_images" {
  compartment_id = var.tenancy_ocid
  operating_system = "Oracle Linux"
  operating_system_version = "8"
  shape = var.shape
}