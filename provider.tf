terraform {
  required_providers {
    scp = {
      version = "1.8.5"
      source = "SamsungSDSCloud/samsungcloudplatform"
    }
  }
  required_version = ">= 0.13"
}

provider "scp" {
}

#data "scp_region" "my_region" {
#}

// Create a new VPC instance
#resource "scp_vpc" "vpc01" {
#  name        = "EshopMgmtVpc"
#  description = "VPC generated from Terraform"
#  region      = data.scp_region.my_region.location
#  region = "KR-WEST-1"
#}

