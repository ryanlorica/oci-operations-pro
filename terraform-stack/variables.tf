# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

### Common Variables ###########################################################

variable "region" {
  description = "Region name. List regions with 'oci iam region list'"
  type        = string
}
variable "compartment_id" {
  description = "Compartment OCID to place resources"
  type        = string
  sensitive   = true
}
variable "all_services_id" {
  description = <<-EOT
    Region-specific service OCID for all services in the Oracle Services Network.
    List with 'oci network service list' from the appropriate region.
    EOT
  type        = string
}
variable "all_services_cidr" {
  description = <<-EOT
    Region-specific service CIDR for all services in the Oracle Services Network.
    List with 'oci network service list' from the appropriate region.
    EOT
  type        = string
}

### VCN ########################################################################

# VCN
variable "vcn_cidr_blocks" {
  description = "List of CIDR blocks for the private IPv4s of the VCN"
  type        = list(string)
}
variable "vcn_display_name" {
  description = "Display name for the VCN"
  type        = string
}
variable "vcn_dns_label" {
  description = "Private DNS label for within the VCN"
  type        = string
}

# Gateways
variable "internet_gateway_display_name" {
  description = "Display name for the internet gateway"
  type        = string
}
variable "service_gateway_display_name" {
  description = "Display name for the service gateway"
  type        = string
}
variable "nat_gateway_display_name" {
  description = "Display name for the NAT gateway"
  type        = string
}

# Route Tables
variable "public_route_table_display_name" {
  description = "Display name for the public route table"
  type        = string
}
variable "private_route_table_display_name" {
  description = "Display name for the private route table"
  type        = string
}

# Public Subnet
variable "public_subnet_cidr_block" {
  description = "Single private IPv4 CIDR block for the public subnet"
  type        = string
}
variable "public_subnet_display_name" {
  description = "Display name for the public subnet"
  type        = string
}
variable "public_subnet_dns_label" {
  description = "Private DNS label for within the public subnet"
  type        = string
}

# Private Subnet
variable "private_subnet_cidr_block" {
  description = "Single private IPv4 CIDR block for the private subnet"
  type        = string
}
variable "private_subnet_display_name" {
  description = "Display name for the private subnet"
  type        = string
}
variable "private_subnet_dns_label" {
  description = "Private DNS label for within the private subnet"
  type        = string
}

### Network Security Groups ####################################################

variable "rails_nsg_display_name" {
  description = "Display name for the Rails NSG"
  type        = string
}
variable "redis_nsg_display_name" {
  description = "Display name for the Redis NSG"
  type        = string
}
variable "postgres_nsg_display_name" {
  description = "Display name for the PostgreSQL NSG"
  type        = string
}
variable "file_storage_nsg_display_name" {
  description = "Display name for the File Storage NSG"
  type        = string
}

### PostgreSQL Instance ########################################################

variable "postgres_availability_domain" {
  type = string
}
variable "postgres_instance_shape" {
  type = string
}
variable "postgres_instance_ocpus" {
  type = number
}
variable "postgres_instance_memory_in_gbs" {
  type = number
}
variable "postgres_instance_image_id" {
  type = string
}
variable "postgres_instance_display_name" {
  type = string
}
variable "postgres_instance_hostname" {
  type = string
}
variable "postgres_instance_ssh_keys" {
  type = string
}

### Redis Instance #############################################################

variable "redis_availability_domain" {
  type = string
}
variable "redis_instance_shape" {
  type = string
}
variable "redis_instance_ocpus" {
  type = number
}
variable "redis_instance_memory_in_gbs" {
  type = number
}
variable "redis_instance_image_id" {
  type = string
}
variable "redis_instance_display_name" {
  type = string
}
variable "redis_instance_hostname" {
  type = string
}
variable "redis_instance_ssh_keys" {
  type = string
}
variable "redis_password" {
  type      = string
  sensitive = true
}

### Mastodon Instance ##########################################################

variable "mastodon_availability_domain" {
  type = string
}
variable "mastodon_instance_shape" {
  type = string
}
variable "mastodon_instance_ocpus" {
  type = number
}
variable "mastodon_instance_memory_in_gbs" {
  type = number
}
variable "mastodon_instance_image_id" {
  type = string
}
variable "mastodon_instance_display_name" {
  type = string
}
variable "mastodon_instance_hostname" {
  type = string
}
variable "mastodon_instance_ssh_keys" {
  type = string
}

### File Storage ###############################################################

variable "file_system_availability_domain" {
  type = string
}
variable "file_system_display_name" {
  type = string
}
variable "mount_target_display_name" {
  type = string
}
variable "mount_target_hostname" {
  type = string
}
variable "file_storage_export_path" {
  type = string
}

### Object Storage #############################################################

variable "object_storage_namespace" {
  type      = string
  sensitive = true
}
variable "mastodon_bucket_name" {
  type = string
}
variable "postgres_bucket_name" {
  type = string
}
variable "mastodon_bucket_infrequent_access_days" {
  type = number
}
variable "mastodon_bucket_infrequent_access_enabled" {
  type = bool
}
variable "postgres_bucket_archive_days" {
  type = number
}
variable "postgres_bucket_archive_enabled" {
  type = bool
}
variable "postgres_bucket_delete_years" {
  type = number
}
variable "postgres_bucket_delete_enabled" {
  type = bool
}