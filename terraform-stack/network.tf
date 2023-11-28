# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

# VCN
resource "oci_core_vcn" "mastodon_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = var.vcn_cidr_blocks
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}

# Gateways
resource "oci_core_internet_gateway" "mastodon_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.internet_gateway_display_name
}
resource "oci_core_service_gateway" "mastodon_service_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.service_gateway_display_name
  services {
    service_id = var.all_services_id
  }
}
resource "oci_core_nat_gateway" "mastodon_nat_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.nat_gateway_display_name
}

# Route tables
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.public_route_table_display_name
  route_rules {
    network_entity_id = oci_core_internet_gateway.mastodon_internet_gateway.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
}
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.private_route_table_display_name
  route_rules {
    network_entity_id = oci_core_nat_gateway.mastodon_nat_gateway.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }
  route_rules {
    network_entity_id = oci_core_service_gateway.mastodon_service_gateway.id
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = var.all_services_cidr
  }
}

# Subnets
resource "oci_core_subnet" "mastodon_public_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  cidr_block     = var.public_subnet_cidr_block
  display_name   = var.public_subnet_display_name
  dns_label      = var.public_subnet_dns_label
  route_table_id = oci_core_route_table.public_route_table.id
  security_list_ids = [
    oci_core_vcn.mastodon_vcn.default_security_list_id
  ]
  prohibit_public_ip_on_vnic = false
}
resource "oci_core_subnet" "mastodon_private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  cidr_block     = var.private_subnet_cidr_block
  display_name   = var.private_subnet_display_name
  dns_label      = var.private_subnet_dns_label
  route_table_id = oci_core_route_table.private_route_table.id
  security_list_ids = [
    oci_core_vcn.mastodon_vcn.default_security_list_id
  ]
  prohibit_public_ip_on_vnic = true
}