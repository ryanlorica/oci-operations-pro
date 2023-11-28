# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

resource "oci_core_instance" "redis_instance" {
  compartment_id      = var.compartment_id
  availability_domain = var.redis_availability_domain
  create_vnic_details {
    subnet_id      = oci_core_subnet.mastodon_private_subnet.id
    hostname_label = var.redis_instance_hostname
    nsg_ids = [
      oci_core_network_security_group.redis_nsg.id,
      oci_core_network_security_group.file_storage_nsg.id
    ]
    assign_public_ip = false
  }
  shape = var.redis_instance_shape
  shape_config {
    ocpus         = var.redis_instance_ocpus
    memory_in_gbs = var.redis_instance_memory_in_gbs
  }
  source_details {
    source_type = "image"
    source_id   = var.redis_instance_image_id
  }
  display_name = var.redis_instance_display_name
  metadata = {
    ssh_authorized_keys = var.redis_instance_ssh_keys
    user_data           = data.cloudinit_config.redis_init.rendered
  }
}

data "cloudinit_config" "redis_init" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content = templatefile("redis_setup.tftpl", {
      redis_password = var.redis_password
    })
    filename = "redis_setup.tftpl"
  }
}