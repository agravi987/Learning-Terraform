# EC2 Provisioning with Terraform

This section covers the practical, step-by-step process of using Terraform to provision an AWS EC2 instance along with its necessary networking and security configurations. It leverages variables and outputs for a more modular and flexible configuration.

## System Architecture & Configuration

1. **Provider Setup (`terraform.tf` and `providers.tf`)**
   - Configured the project to use the official HashiCorp AWS provider (version `~> 6.0`).
   - Defined the AWS region dynamically using the `var.ec2_region` variable in the `provider` block.

2. **Variables (`variables.tf`)**
   - Utilizes parameters to make the configuration reusable across environments.
   - Includes variables like `env_prefix`, `ec2_instance_type`, `ec2_root_storage_size`, `ec2_root_storage_type`, `ec2_region`, and `ssh_allowed_cidr`.

3. **SSH Key Pair (`aws_key_pair` in `ec2.tf`)**
   - Created a resource to upload a previously generated local public SSH key (`terra-key-ec2.pub`) to AWS.
   - Names the key dynamically using the `env_prefix` variable.
   - This provisions secure SSH access for the EC2 instance.

4. **Networking Strategy (`data.aws_vpc` & `aws_security_group` in `ec2.tf`)**
   - Uses a `data "aws_vpc"` block to fetch the default VPC in the region dynamically.
   - Created a custom **Security Group** (`my_sg`) to define the network firewall rules:
     - **Inbound (Ingress):** Open to `SSH (port 22)` from `var.ssh_allowed_cidr` (providing better security control), `HTTP (port 80)`, and `HTTPS (port 443)` from anywhere (`0.0.0.0/0`).
     - **Outbound (Egress):** Allows all outbound traffic for standard communication.

5. **Dynamic AMI Lookup (`data.aws_ami` in `ec2.tf`)**
   - Uses a Terraform `data` source to avoid hardcoding AMI IDs which frequently update and are region-specific.
   - Filters for the latest **Amazon Linux 2** AMI built by Amazon (`amzn2-ami-hvm-*-x86_64-gp2`).

6. **EC2 Instance Provisioning (`aws_instance` in `ec2.tf`)**
   - Provisions an `aws_instance` (`my_ec2_instance`).
   - Sources the AMI dynamically from the `data` block and uses `var.ec2_instance_type` for the instance type.
   - Attaches the defined `aws_key_pair` and the `aws_security_group`.
   - Configures the root drive storage dynamically via a `root_block_device` block using `var.ec2_root_storage_size` and `var.ec2_root_storage_type`.
   - Tags the instance using the `env_prefix` variable.

7. **Outputs (`outputs.tf`)**
   - Exposes critical infrastructure details after applying the configuration.
   - Outputs include the instance's public IP (`ec2_public_ip`), private IP, public DNS, instance ID, AMI ID, security group IDs, and root block device details.

## Advanced Terraform Concepts

This project demonstrates several advanced Terraform configuration techniques:

1. **The `for_each` Meta-Argument**
   - Used in the `aws_instance` block to loop over a map of instance names and types (e.g., `web1-micro = t2.micro`).
   - `for_each` is safer than `count` for identical resources because removing one item from the map only destroys that specific instance, rather than re-indexing and recreating others.
   - Accesses the current item using `each.key` and `each.value`.

2. **The `count` Meta-Argument (Alternative to `for_each`)**
   - While `for_each` is used here, `count` can also be used to spin up multiple identical resources (e.g., `count = 3` creates three identical copies of the resource).
   - Resources created with `count` are accessed as a list (e.g., `aws_instance.my_ec2_instance[0]`).

3. **Explicit Dependencies (`depends_on`)**
   - While Terraform automatically determines implicit dependencies based on resource references (like referencing `aws_security_group.my_sg.id` inside an EC2 instance), `depends_on` can be used to enforce a strict creation order.
   - Enforces that the security group, key pair, and AMI data source are fully processed before the EC2 instance tries to create itself.

4. **Conditional Expressions (Ternary Operator)**
   - Used to apply dynamic logic directly within resource arguments: `condition ? true_val : false_val`.
   - Used in the `root_block_device` to determine the volume size based on the environment: `volume_size = var.env_prefix == "dev" ? var.ec2_default_root_storage_size : var.ec2_default_root_storage_size + 10`. This keeps the configuration DRY while supporting multiple environments.

## Usage Guide
- Generate the SSH key before running Terraform:
  ```bash
  ssh-keygen -t rsa -b 2048 -f terra-key-ec2
  ```
- Run `terraform init` to download the recommended AWS provider.
- Run `terraform plan` to preview the provisioned infrastructure.
- Run `terraform apply` to create the cloud resources.
