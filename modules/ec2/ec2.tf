data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.aws_ami_virtualization_type]
  }

  owners = [var.aws_ami_owner] # Canonical
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # the VPC subnet
  subnet_id = element(var.public_subnets, 0)

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = var.key_name
  associate_public_ip_address = var.public_ip_address

  tags = {
    Name         = var.name
  }
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.vpc_id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
