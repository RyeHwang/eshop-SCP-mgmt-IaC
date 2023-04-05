data "scp_standard_image" "ubuntu_image_vm" {
    service_group = "COMPUTE"
    service       = "Virtual Server"
    region        = var.region
    filter {
        name = "image_name"
        values = ["Ubuntu 20.04"]
        use_regex = true
    }
}
resource "scp_virtual_server" "bastion" {
    //name_prefix         = "eshop-bastion"   # will be rolled back after v1.8.6
    //timezone            = "Asia/Seoul"     # will be rolled back after v1.8.6
    virtual_server_name = "eshop-bastion"     # will be deleted after v1.8.6
    admin_account       = "root"
    admin_password      = var.bastion_password
    cpu_count           = 1
    memory_size_gb      = 2
    image_id            = data.scp_standard_image.ubuntu_image_vm.id
    vpc_id              = scp_vpc.mgmt_vpc.id
    subnet_id           = scp_subnet.public.id

    delete_protection   = false
    contract_discount   = "None"

    os_storage_name     = "eshopBtDisk1"
    os_storage_size_gb  = 100
    os_storage_encrypted = false

    #initial_script_content = "/test"
    public_ip_id        = scp_public_ip.bastion_ip.id
    security_group_ids  = [
        scp_security_group.bastion_sg.id 
    ]
    use_dns = true
}

resource "scp_public_ip" "bastion_ip" {
    description = "Public IP generated from Terraform"
    region      = var.region
}

resource "scp_virtual_server" "admin" {
    //name_prefix         = "eshop-admin"   # will be rolled back after v1.8.6 
    //timezone            = "Asia/Seoul"   # will be rolled back after v1.8.6
    virtual_server_name = "eshop-admin"     # will be deleted after v1.8.6 
    admin_account       = "root"
    admin_password      = var.admin_password
    cpu_count           = 2
    memory_size_gb      = 4
    image_id            = data.scp_standard_image.ubuntu_image_vm.id
    vpc_id              = scp_vpc.mgmt_vpc.id
    subnet_id           = scp_subnet.private.id

    delete_protection   = false
    contract_discount   = "None"

    os_storage_name     = "eshopAdDisk1"
    os_storage_size_gb  = 100
    os_storage_encrypted = false

    initial_script_content = <<EOF
# kubectl 설치
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# alias 설정
echo 'alias cls=clear' >> /root/.bashrc
echo 'export PATH=$PATH:/home/root/bin' >> /root/.bashrc
echo 'source <(kubectl completion bash)' >> /root/.bashrc
echo 'alias k=kubectl' >> /root/.bashrc
echo 'complete -F __start_kubectl k' >> /root/.bashrc    
# alias 추가
alias mc='kubectl config use-context mgmt' >> /root/.bashrc
alias ec='kubectl config use-context eshop' >> /root/.bashrc
# WhereAmI
alias wai='kubectl config get-contexts'	>> /root/.bashrc
EOF

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
