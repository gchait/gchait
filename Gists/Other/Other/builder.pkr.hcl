packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "al2023" {
  ami_name      = "builder"
  instance_type = "t2.micro"
  region        = "eu-west-3"
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-minimal-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners      = ["137112412989"]
  }
}

build {
  name = "builder"
  sources = ["source.amazon-ebs.al2023"]

  provisioner "shell" {
    inline = [
      <<-EOF
      bootstrap() {
        dnf update -y
        dnf install --setopt=install_weak_deps=false -y java-21-amazon-corretto maven python3.11 python3.11-pip nodejs-npm openssl git docker awscli-2 tar gzip zip unzip bind-utils wget jq vim nano which nc tree

        npm config set update-notifier false
        npm install yarn -g

        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin/ 2>&1

        wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
        chmod +x /usr/local/bin/yq

        echo '{"default-address-pools":[{"base":"10.2.0.0/16","size":24}]}' > /etc/docker/daemon.json
        systemctl enable docker 2>&1
        usermod -aG docker ec2-user
      }

      sudo bash -ce "$(declare -f bootstrap); bootstrap"
      EOF
    ]
  }
}
