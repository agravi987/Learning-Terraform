# 🚀 Terraform Setup on AWS EC2 (Ubuntu) – Complete Documentation

## 📌 Overview

This document provides a **production-relevant, end-to-end setup** of Terraform on an AWS EC2 Ubuntu instance. It includes:

* EC2 provisioning basics
* Secure SSH access (PuTTY)
* Terraform installation (official method)
* AWS CLI installation (official fallback)
* AWS authentication setup

---

# 🧱 1. Launch EC2 Instance

### Configuration

* **AMI**: Ubuntu Server (recommended)
* **Instance Type**: t2.micro (Free Tier)
* **Key Pair**: Download `.pem` file
* **Security Group**:

  * Allow SSH (Port 22)

### Output Required

* Public IP address
* Key pair (.pem file)

---

# 🔐 2. Connect to EC2 using PuTTY (Windows)

## Step 1: Convert PEM to PPK

Use PuTTYgen:

* Load `.pem`
* Save private key as `.ppk`

## Step 2: Connect via PuTTY

* Host: `ubuntu@<public-ip>`
* Auth → Select `.ppk`

---

# ⚙️ 3. Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

---

# 📦 4. Install Terraform (Official Method)

Follow HashiCorp official repository method:

## Step 1: Install dependencies

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
```

## Step 2: Add HashiCorp GPG key

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```

## Step 3: Add repository

```bash
sudo apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

## Step 4: Install Terraform

```bash
sudo apt-get update && sudo apt-get install terraform -y
```

## Step 5: Verify

```bash
terraform -version
```

---

# ⚠️ 5. AWS CLI Installation Issue (Observed)

## Problem

```bash
Package 'awscli' has no installation candidate
```

## Root Cause

* Outdated or minimal Ubuntu repositories
* awscli not available in repo index

---

# ✅ 6. Install AWS CLI (Official Method – Recommended)

## Step 1: Download

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

## Step 2: Install unzip

```bash
sudo apt install unzip -y
```

## Step 3: Extract

```bash
unzip awscliv2.zip
```

## Step 4: Install

```bash
sudo ./aws/install
```

## Step 5: Verify

```bash
aws --version
```

Expected output:

```
aws-cli/2.x.x
```

---

# 🔑 7. Configure AWS Credentials

```bash
aws configure
```

Provide:

* AWS Access Key
* AWS Secret Key
* Region (e.g., ap-south-1)
* Output: json

---

# 🔍 8. Verify AWS Access

```bash
aws sts get-caller-identity
```

---

# 🧪 9. Test Terraform with AWS

Create file:

```bash
nano main.tf
```

### Sample Configuration

```hcl
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
}
```

### Run Terraform

```bash
terraform init
terraform plan
terraform apply
```

---

# 🧠 10. Architecture Flow

```
Local Machine → PuTTY → EC2 → Terraform → AWS API → Infrastructure
```

---

# 📚 Official Documentation Links

## Terraform Installation (Official)

[https://developer.hashicorp.com/terraform/install#linux](https://developer.hashicorp.com/terraform/install#linux)

## Terraform AWS Getting Started

[https://developer.hashicorp.com/terraform/tutorials/aws-get-started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)

## AWS CLI Installation

[https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

---

# 💡 Best Practices (Important)

* Prefer **official installation methods** over OS package managers
* Avoid storing credentials using `aws configure` in production
* Use **IAM Roles for EC2** instead
* Store Terraform code in version control (GitHub)
* Use remote backend (S3 + DynamoDB) for state management

---

# ✅ Final Status

✔ EC2 instance created
✔ Connected via PuTTY
✔ Terraform installed (official repo)
✔ AWS CLI installed (manual method)
✔ AWS credentials configured
✔ Terraform successfully tested

---

# 🚀 Next Steps

* IAM Role setup for EC2
* Terraform remote backend (S3 + DynamoDB)
* CI/CD integration (Jenkins + Terraform)

---

**End of Documentation**
