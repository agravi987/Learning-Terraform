# HashiCorp Configuration Language (HCL) - Quick Reference

## What is HCL?
HCL (HashiCorp Configuration Language) is a declarative, domain-specific language used by Terraform to provision and manage infrastructure. It is designed to be both human-readable and machine-friendly.

## Basic Syntax Structure
HCL is built around **blocks**, **arguments**, and **expressions**.

```hcl
<block_type> "<label_1>" "<label_2>" {
  <argument_name> = <expression>
}
```

**Example:**
```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

## Key Components

1. **Blocks**: Containers for other content. They represent objects like resources, data sources, providers, or variables. A block has a type, zero or more labels, and a body enclosed in `{}`.
2. **Arguments**: Assign a value to a name. They represent the parameters of a block. E.g., `ami = "..."`
3. **Expressions**: Represent a value, either directly (literal) or by referencing other values or applying operators.

## Data Types

### Primitive Types
- **String**: Sequences of Unicode characters. (e.g., `"hello"`)
- **Number**: Numeric values (both integers and floats). (e.g., `42`, `3.14`)
- **Bool**: Boolean values. (`true` or `false`)

### Complex Types
- **List/Tuple**: Ordered sequences of values. (e.g., `["us-east-1a", "us-east-1b"]`)
- **Map/Object**: Unordered groups of key-value pairs. (e.g., `{ name = "app", env = "prod" }`)

## Comments
HCL supports three types of comments:
- `#` : Single-line comment (Recommended standard).
- `//` : Single-line comment (Alternative).
- `/* ... */` : Multi-line block comment.

## Essential Best Practices
- **Indentation**: Use 2 spaces for indentation.
- **Naming Conventions**: Use `snake_case` for resource names, variables, and outputs.
- **Declarative Approach**: Focus on *what* the end state should be, not *how* to achieve it.

## High-Level Example

Here is a complete, real-world example of an HCL configuration (typically named `main.tf`) that provisions an AWS EC2 instance along with a security group.

```hcl
# 1. Terraform Block: Defines terraform settings and required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. Provider Block: Configures the specific provider (AWS in this case)
provider "aws" {
  region = "us-east-1"
}

# 3. Variable Block: Defines input parameters for the configuration
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "MyWebAppServer"
}

# 4. Resource Block (Security Group): Defines a piece of infrastructure
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP traffic"

  # Ingress block (Argument that takes a nested block)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Resource Block (EC2 Instance): References the security group above
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  # Reference expression: linking this instance to the security group created above
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Map type argument
  tags = {
    Name        = var.instance_name # Variable reference
    Environment = "Dev"
  }
}

# 6. Output Block: Defines values to return after applying the code
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}
```

### Understanding the Example:
- **`terraform {}`**: Instructs Terraform which provider plugins to download (AWS in this case).
- **`provider "aws" {}`**: Sets up the connection details (like the region) for AWS.
- **`variable "instance_name" {}`**: Acts as a parameter for our code to keep it dynamic, avoiding hardcoded values.
- **`resource "aws_security_group" ...`**: Creates a firewall rule allowing TCP port 80 (HTTP) traffic.
- **`resource "aws_instance" ...`**: Creates the actual virtual machine. Notice how `vpc_security_group_ids = [aws_security_group.web_sg.id]` creates a strict dependency—Terraform automatically knows it must create the Security Group *before* the EC2 instance because of this reference.
- **`output "instance_public_ip" {}`**: Prints the machine's public IP address to the console after Terraform finishes, so you don't have to look it up in the AWS console.
