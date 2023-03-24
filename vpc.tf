data "scp_region" "my_region" {}

resource "scp_vpc" "mgmt_vpc" {
  name         = "eshopMgmtVpc"
  description  = "Vpc generated from Terraform"
  //region       = data.scp_region.my_region.location
  region       = var.region
}

resource "scp_subnet" "public" {
  vpc_id       = scp_vpc.mgmt_vpc.id
  name         = "eshopMgmtPuSubnet"
  type         = "PUBLIC"
  cidr_ipv4    = "10.0.1.0/24"
  description  = "public subnet generated from Terraform"

  depends_on    = [scp_vpc.mgmt_vpc]
}

resource "scp_subnet" "private" {
  vpc_id       = scp_vpc.mgmt_vpc.id
  name         = "eshopMgmtPrSubnet"
  type         = "PRIVATE"
  cidr_ipv4    = "10.0.11.0/24"
  description  = "private subnet generated from Terraform"

  depends_on    = [scp_internet_gateway.mgmt_igw]
}

resource "scp_internet_gateway" "mgmt_igw" {
  vpc_id       = scp_vpc.mgmt_vpc.id
  description  = "Internet GW generated from Terraform"

  depends_on    = [scp_vpc.mgmt_vpc]
}
