variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_default_root_storage_size" {
  type    = number
  default = 10
}

variable "ec2_root_storage_type" {
  type    = string
  default = "gp3"
}

variable "ec2_region" {
  type    = string
  default = "us-east-1"
}

variable "env_prefix" {
  type    = string
  default = "prod"
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into the instance. Change this to your IP for better security."
  type        = string
  default     = "0.0.0.0/0"
}


