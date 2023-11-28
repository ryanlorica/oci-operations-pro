# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

resource "oci_file_storage_file_system" "mastodon_file_system" {
  compartment_id      = var.compartment_id
  availability_domain = var.file_system_availability_domain
  display_name        = var.file_system_display_name
}
resource "oci_file_storage_mount_target" "mastodon_mount_target" {
  compartment_id      = var.compartment_id
  availability_domain = var.file_system_availability_domain

  subnet_id = oci_core_subnet.mastodon_private_subnet.id
  nsg_ids = [
    oci_core_network_security_group.file_storage_nsg.id
  ]

  display_name   = var.mount_target_display_name
  hostname_label = var.mount_target_hostname
}
resource "oci_file_storage_export" "mastodon_file_storage_export" {
  file_system_id = oci_file_storage_file_system.mastodon_file_system.id
  export_set_id  = oci_file_storage_mount_target.mastodon_mount_target.export_set_id
  path           = var.file_storage_export_path
}