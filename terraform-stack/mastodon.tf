# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

resource "oci_core_instance" "mastodon_instance" {
  compartment_id      = var.compartment_id
  availability_domain = var.mastodon_availability_domain
  create_vnic_details {
    subnet_id      = oci_core_subnet.mastodon_public_subnet.id
    hostname_label = var.mastodon_instance_hostname
    nsg_ids = [
      oci_core_network_security_group.rails_nsg.id,
      oci_core_network_security_group.file_storage_nsg.id
    ]
    assign_public_ip = true
  }
  shape = var.mastodon_instance_shape
  shape_config {
    ocpus         = var.mastodon_instance_ocpus
    memory_in_gbs = var.mastodon_instance_memory_in_gbs
  }
  source_details {
    source_type = "image"
    source_id   = var.mastodon_instance_image_id
  }
  display_name = var.mastodon_instance_display_name
  metadata = {
    ssh_authorized_keys = var.mastodon_instance_ssh_keys
    user_data           = data.cloudinit_config.mastodon_init.rendered
  }
}

data "cloudinit_config" "mastodon_init" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = file("mastodon_setup.sh")
    filename     = "mastodon_setup.sh"
  }
}