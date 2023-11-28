# Copyright (c) 2023, Oracle and/or its affiliates.  All rights reserved.
#
# This software is dual-licensed to you under the Universal Permissive License 
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl or Apache License 
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose 
# either license.

terraform {
  required_version = "~> 1.2.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.111.0"
    }
  }
}

provider "oci" {
  region = var.region
}