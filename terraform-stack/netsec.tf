# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

# Rails NSG
resource "oci_core_network_security_group" "rails_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.rails_nsg_display_name
}
resource "oci_core_network_security_group_security_rule" "rails_rule_0" {
  network_security_group_id = oci_core_network_security_group.rails_nsg.id
  direction                 = "INGRESS"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  protocol                  = 6 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}
resource "oci_core_network_security_group_security_rule" "rails_rule_1" {
  network_security_group_id = oci_core_network_security_group.rails_nsg.id
  direction                 = "INGRESS"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  protocol                  = 6 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# Redis NSG
resource "oci_core_network_security_group" "redis_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.redis_nsg_display_name
}
resource "oci_core_network_security_group_security_rule" "redis_rule" {
  network_security_group_id = oci_core_network_security_group.redis_nsg.id
  direction                 = "INGRESS"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.rails_nsg.id
  protocol                  = 6 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  tcp_options {
    destination_port_range {
      min = 6379
      max = 6379
    }
  }
}

# PostgreSQL NSG
resource "oci_core_network_security_group" "postgres_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.postgres_nsg_display_name
}
resource "oci_core_network_security_group_security_rule" "postgres_rule" {
  network_security_group_id = oci_core_network_security_group.postgres_nsg.id
  direction                 = "INGRESS"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.rails_nsg.id
  protocol                  = 6 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}

# File Storage NSG
resource "oci_core_network_security_group" "file_storage_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mastodon_vcn.id
  display_name   = var.file_storage_nsg_display_name
}
resource "oci_core_network_security_group_security_rule" "file_storage_tcp_rule_0" {
  network_security_group_id = oci_core_network_security_group.file_storage_nsg.id
  direction                 = "INGRESS"
  source_type               = "CIDR_BLOCK"
  source                    = var.vcn_cidr_blocks[0]
  # source                    = each.key
  protocol                  = 6 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  tcp_options {
    destination_port_range {
      min = 111
      max = 111
    }
  }
  # for_each = toset(var.vcn_cidr_blocks)
}
resource "oci_core_network_security_group_security_rule" "file_storage_tcp_rule_1" {
  network_security_group_id = oci_core_network_security_group.file_storage_nsg.id
  direction                 = "INGRESS"
  source_type               = "CIDR_BLOCK"
  source                    = var.vcn_cidr_blocks[0]
  # source                    = each.key
  protocol                  = 6 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  tcp_options {
    destination_port_range {
      min = 2048
      max = 2050
    }
  }
  # for_each = toset(var.vcn_cidr_blocks)
}
resource "oci_core_network_security_group_security_rule" "file_storage_udp_rule" {
  network_security_group_id = oci_core_network_security_group.file_storage_nsg.id
  direction                 = "INGRESS"
  source_type               = "CIDR_BLOCK"
  source                    = var.vcn_cidr_blocks[0]
  # source                    = each.key
  protocol                  = 17 # ICMP=1, TCP=6, UDP=17, ICMPv6=56
  udp_options {
    destination_port_range {
      min = 111
      max = 111
    }
  }
  # for_each = toset(var.vcn_cidr_blocks)
}