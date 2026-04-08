resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env_prefix}-terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_security_group" "my_sg" {
  name   = "${var.env_prefix}-security-group"
  vpc_id = data.aws_vpc.default_vpc.id

  # SSH (restrict this in real-world 🚨)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound (allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-security-group"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


resource "aws_instance" "my_ec2_instance" {

  for_each = tomap({
    "web1-micro"  = "t2.micro"
    "web2-medium" = "t2.medium"
    "web3-large"  = "t2.large"
  })

  depends_on = [aws_security_group.my_sg, aws_key_pair.my_key_pair, data.aws_ami.ubuntu]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  user_data = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env_prefix == "dev" ? var.ec2_default_root_storage_size : var.ec2_default_root_storage_size + 10
    volume_type = var.ec2_root_storage_type
  }

  tags = {
    Name = "${var.env_prefix}-ec2-instance"
  }
}

