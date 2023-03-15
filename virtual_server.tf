data "scp_standard_image" "ubuntu_image" {
    service_group = "COMPUTE"
    service       = "Virtual Server"
    region        = data.scp_region.region.location
    filter {
        name = "image_name"
        values = ["Ubuntu 20.04"]
    }
}
resource "scp_virtual_server" "bastion" {
    name_prefix         = "eshopbastion"   
    admin_account       = "root"
    admin_password      = var.bastion_password
    cpu_count           = 2
    memory_size_gb      = 4
    image_id            = data.scp_standard_image.ubuntu_image.id
    vpc_id              = scp_vpc.mgmt_vpc.id
    subnet_id           = scp_subnet.public.id

    delete_protection   = false
    timezone            = "Asia/Seoul"     
    contract_discount   = "None"

    os_storage_name     = "eshopBtDisk1"
    os_storage_size_gb  = 100
    os_storage_encrypted = false

    #initial_script_content = "/test"
#    public_ip_id        = "123.37.4.153"
    security_group_ids  = [
        scp_security_group.bastion_sg.id 
    ]
    use_dns = true
/*
    external_storage {
        name            = eshopExtStorage
        product_name    = "SSD"
        storage_size_gb = 10
        encrypted       = false
    }
*/
}


resource "scp_virtual_server" "admin" {
    name_prefix         = "eshopadmin"   # not in manual. newly updated
    timezone            = "Asia/Seoul"       # not in maunal. newly updated
    admin_account       = "root"
    admin_password      = var.admin_password
    cpu_count           = 2
    memory_size_gb      = 4
    image_id            = data.scp_standard_image.ubuntu_image.id
    vpc_id              = scp_vpc.mgmt_vpc.id
    subnet_id           = scp_subnet.private.id

    delete_protection   = false
    contract_discount   = "None"

    os_storage_name     = "eshopAdDisk1"
    os_storage_size_gb  = 100
    os_storage_encrypted = false

    #initial_script_content = "/test"

    security_group_ids = [
        scp_security_group.admin_sg.id 
    ]
    use_dns = true
/*
    external_storage {
        name            = eshopExtStorage
        product_name    = "SSD"
        storage_size_gb = 10
        encrypted       = false
    }
*/
}
