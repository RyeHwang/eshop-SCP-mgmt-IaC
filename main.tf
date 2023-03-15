data "scp_region" "region" {}

resource "scp_security_group" "bastion_sg" {
  vpc_id       = scp_vpc.mgmt_vpc.id
  name         = "eshopMgmtBtSG"
  description  = "eshop management bastion server security group"
}

resource "scp_security_group" "admin_sg" {
  vpc_id       = scp_vpc.mgmt_vpc.id
  name         = "eshopMgmtAdSG"
  description  = "eshop management admin server security group"
}

resource "scp_security_group_rule" "admin_rule_tcp" {
    security_group_id = scp_security_group.admin_sg.id 
#    source_security_group_id = scp_security_group.bastion_sg.id 
    direction         = "in"
    description       = "ssh SG rule generated from Terraform"
    addresses_ipv4 = ["10.0.1.0/24"]
    service { 
        type = "tcp" 
        value = 22
    }
}

resource "scp_security_group_rule" "admin_rule_all" {
    security_group_id = scp_security_group.admin_sg.id 
    direction         = "out"
    description       = "SG out rule generated from Terraform"
    addresses_ipv4 = ["0.0.0.0/0"]
    service { 
        type = "tcp" 
        value = 22
    }
}

resource "scp_security_group_rule" "bastion_rule_all" {
    security_group_id = scp_security_group.bastion_sg.id 
    direction         = "out"
    description       = "SG out rule generated from Terraform"
    addresses_ipv4 = ["0.0.0.0/0"]
    service { type = "all" }
}

resource "scp_security_group_rule" "bastion_rule_tcp" {
    security_group_id = scp_security_group.bastion_sg.id 
    direction         = "in"
    description       = "TCP SG rule generated from Terraform"
    addresses_ipv4 = ["0.0.0.0/0"]
    service { 
        type = "tcp" 
        value = 80
    }
}

resource "scp_security_group_rule" "bastion_rule_ssh" {
    security_group_id = scp_security_group.bastion_sg.id 
    direction         = "in"
    description       = "SSH SG rule generated from Terraform"
    addresses_ipv4 = ["112.152.240.50/32"]
    service { 
        type = "tcp" 
        value = 22
    }
}