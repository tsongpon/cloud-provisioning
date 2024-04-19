terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "tsongpon-terraform-backend"
    key    = "swarm_cluster"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region  = "ap-southeast-1"
}

resource "aws_instance" "swarm-master" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = "songpon-aws-keypair"
  subnet_id = "subnet-0abd5d096a2b460f6"
  security_groups = [ "sg-00e3c3bffc97ab859", "sg-01744f68dc12cffdb" ]
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 20
  }

    ### Install Docker
  user_data = <<-EOF
    #!/bin/bash
    sudo hostnamectl set-hostname swarm-master

    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker ubuntu

    sudo apt install -y nfs-common
    sudo mkdir -p /mnt/vol
    echo '10.0.13.6:/nfs/vol /mnt/vol nfs soft,intr,rsize=8192,wsize=8192' | sudo tee -a /etc/fstab
    sudo mount 10.0.13.6:/nfs/vol

    # # install glusterfs server
    # sudo apt install -y software-properties-common
    # sudo add-apt-repository -y ppa:gluster/glusterfs-11
    # sudo apt update
    # sudo apt install -y glusterfs-server
    # sudo systemctl start glusterd
    # sudo systemctl enable glusterd
  EOF

  tags = {
    Name = "swarm-master"
  }
}

resource "aws_instance" "swarm-worker-1" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = "songpon-aws-keypair"
  subnet_id = "subnet-0abd5d096a2b460f6"
  security_groups = [ "sg-00e3c3bffc97ab859", "sg-01744f68dc12cffdb" ]
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 20
  }

    ### Install Docker
  user_data = <<-EOF
    #!/bin/bash
    sudo hostnamectl set-hostname swarm-worker-1
    
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker ubuntu

    sudo apt install -y nfs-common
    sudo mkdir -p /mnt/vol
    echo '10.0.13.6:/nfs/vol /mnt/vol nfs soft,intr,rsize=8192,wsize=8192' | sudo tee -a /etc/fstab
    sudo mount 10.0.13.6:/nfs/vol

    # # install glusterfs server
    # sudo apt install -y software-properties-common
    # sudo add-apt-repository -y ppa:gluster/glusterfs-11
    # sudo apt update
    # sudo apt install -y glusterfs-server
    # sudo systemctl start glusterd
    # sudo systemctl enable glusterd
  EOF

  tags = {
    Name = "swarm-worker-1"
  }
}

resource "aws_instance" "swarm-worker-2" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = "songpon-aws-keypair"
  subnet_id = "subnet-0abd5d096a2b460f6"
  security_groups = [ "sg-00e3c3bffc97ab859", "sg-01744f68dc12cffdb" ]
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 20
  }

    ### Install Docker
  user_data = <<-EOF
    #!/bin/bash
    sudo hostnamectl set-hostname swarm-worker-2

    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker ubuntu

    sudo apt install -y nfs-common
    sudo mkdir -p /mnt/vol
    echo '10.0.13.6:/nfs/vol /mnt/vol nfs soft,intr,rsize=8192,wsize=8192' | sudo tee -a /etc/fstab
    sudo mount 10.0.13.6:/nfs/vol

    # # install glusterfs server
    # sudo apt install -y software-properties-common
    # sudo add-apt-repository -y ppa:gluster/glusterfs-11
    # sudo apt update
    # sudo apt install -y glusterfs-server
    # sudo systemctl start glusterd
    # sudo systemctl enable glusterd
  EOF

  tags = {
    Name = "swarm-worker-2"
  }
}