data "scp_standard_image" "ubuntu_node_image" {
    service_group      = "CONTAINER"
    service            = "Kubernetes Engine VM"
    region             = data.scp_region.region.location

    filter {
        name           = "image_name"
        values         = ["Ubuntu 18.04 (Kubernetes)-v1.24.8"]
        use_regex      = false
    }
}

resource "scp_file_storage" "mgmt_nfs" {
    name               = "eshop_mgmt_nfs"
    disk_type          = "HDD"
    protocol           = "NFS"
    is_encrypted       = false
    retention_count    = 2
    region             = data.scp_region.region.location
}

resource "scp_load_balancer" "mgmt_lb" {
    vpc_id             = scp_vpc.mgmt_vpc.id
    name               = "eshop_mgmt_lb"
    size               = "SMALL"
    cidr_ipv4          = "192.168.102.0/24"
    description        = "LoadBalancer generated from Terraform"
}

resource "scp_kubernetes_engine" "mgmt_cluster" {
    name               = "eshop-mgmt-cluster"
    kubernetes_version = "v1.24.8"

    vpc_id             = scp_vpc.mgmt_vpc.id
    subnet_id          = scp_subnet.private.id
    security_group_id  = scp_security_group.mgmt_cluster_sg.id
    volume_id          = scp_file_storage.mgmt_nfs.id

    cloud_logging_enabled = false
    load_balancer_id   = scp_load_balancer.mgmt_lb.id

    //depends_on         = [scp_file_storage.mgmt_nfs]
}

resource "scp_kubernetes_node_pool" "pool" {
    name               = "eshop-mgmt-node"
    engine_id          = scp_kubernetes_engine.mgmt_cluster.id
    image_id           = data.scp_standard_image.ubuntu_node_image.id
    
    cpu_count          = 2
    memory_size_gb     = 4

    auto_recovery      = true
    auto_scale         = false
    desired_node_count = 2
    min_node_count     = 2
    max_node_count     = 2
}