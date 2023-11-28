# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

# Buckets
resource "oci_objectstorage_bucket" "mastodon_bucket" {
  compartment_id = var.compartment_id
  namespace      = var.object_storage_namespace
  name           = var.mastodon_bucket_name
  access_type    = "NoPublicAccess"
  versioning     = "Enabled"
}
resource "oci_objectstorage_bucket" "postgres_bucket" {
  compartment_id = var.compartment_id
  namespace      = var.object_storage_namespace
  name           = var.postgres_bucket_name
  access_type    = "NoPublicAccess"
  versioning     = "Enabled"
}

# Life Cycle Policies
resource "oci_objectstorage_object_lifecycle_policy" "mastodon_bucket_lifecycle_policy" {
  namespace = var.object_storage_namespace
  bucket    = oci_objectstorage_bucket.mastodon_bucket.name

  rules {
    name        = "MastodonAutoInfrequentAccess"
    target      = "objects"
    action      = "INFREQUENT_ACCESS"
    time_unit   = "DAYS"
    time_amount = var.mastodon_bucket_infrequent_access_days
    is_enabled  = var.mastodon_bucket_infrequent_access_enabled
  }
}
resource "oci_objectstorage_object_lifecycle_policy" "postgres_bucket_lifecycle_policy" {
  namespace = var.object_storage_namespace
  bucket    = oci_objectstorage_bucket.postgres_bucket.name
  rules {
    name        = "PostgresAutoArchive"
    target      = "previous-object-versions"
    action      = "ARCHIVE"
    time_unit   = "DAYS"
    time_amount = var.postgres_bucket_archive_days
    is_enabled  = var.postgres_bucket_archive_enabled
  }
  rules {
    name        = "PostgresAutoDelete"
    target      = "previous-object-versions"
    action      = "DELETE"
    time_unit   = "YEARS"
    time_amount = var.postgres_bucket_delete_years
    is_enabled  = var.postgres_bucket_delete_enabled
  }
}