# EC2 Provisioning with Terraform

This section covers the practical, step-by-step process of using Terraform to provision an AWS EC2 instance along with its necessary networking and security configurations.

## Step-by-Step Implementation

1. **Provider Setup (`terraform.tf` and `providers.tf`)**
   - Configured the project to use the official HashiCorp AWS provider (version `~> 6.0`).
   - Defined the AWS region as `us-east-1` in the `provider` block.

2. **SSH Key Pair (`aws_key_pair`)**
   - Created a resource to upload a previously generated local public SSH key (`terra-key-ec2.pub`) to AWS.
   - This provisions secure SSH access for the future EC2 instance.

3. **Networking Strategy (`aws_default_vpc` & `aws_security_group`)**
   - Declared an `aws_default_vpc` resource block to automatically adopt the default VPC in the region without having to configure subnets manually.
   - Created a custom **Security Group** (`my_security_group`) to define the network firewall rules for our instance:
     - **Inbound (Ingress):** Open to `SSH (port 22)`, `HTTP (port 80)`, and `HTTPS (port 443)` from anywhere (`0.0.0.0/0`).
     - **Outbound (Egress):** Allows all outbound traffic for standard communication.

4. **Dynamic AMI Lookup (`data.aws_ami`)**
   - To avoid hardcoding AMI IDs which frequently update and are region-specific, used a Terraform `data` source.
   - Filtered for the latest **Amazon Linux 2** AMI built by Amazon (`amzn2-ami-hvm-*-x86_64-gp2`).

5. **EC2 Instance Provisioning (`aws_instance`)**
   - Consolidated the above resources by provisioning an actual instance (`my_ec2_instance`).
   - Sourced the AMI dynamically from the `data` block and specified the `t2.micro` instance type (free-tier eligible).
   - Attached the defined `aws_key_pair` and the `aws_security_group`.
   - Upgraded the root drive storage to a `15 GB` `gp3` volume via a `root_block_device` block.
