packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "al2023" {
  ami_name      = "ci-python"
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
  name = "ci-python"
  sources = [
    "source.amazon-ebs.al2023"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker python3-pip virtualenv",
      "python3 -m pip install isort black ruff pytest pylint flake8 bandit poetry pipx",
    ]
  }
}
