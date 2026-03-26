# 🚀 Terraform Setup on Local System (Windows) – Complete Documentation

## 📌 Overview

This document provides a complete guide for setting up **Terraform** and the **AWS CLI** on a local Windows machine. Setting up locally allows you to write, validate, and execute Terraform code efficiently.

---

# 🧱 1. Prerequisites

*   A Windows 10 or 11 operating system.
*   Administrative privileges (for installing software and setting system paths).
*   A terminal (PowerShell, Command Prompt, or Git Bash).
*   An IDE (like Visual Studio Code) with the HashiCorp Terraform extension installed.

---

# 📦 2. Install Terraform (Windows)

There are two primary ways to install Terraform on Windows. The automated method (Chocolatey) is highly recommended for easy updates.

## Option A: Using Chocolatey (Recommended)

Chocolatey is a package manager for Windows (similar to `apt` on Ubuntu).

1.  Open **PowerShell as Administrator**.
2.  Install Chocolatey (if you don't have it) by pasting this command:
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ```
3.  Install Terraform:
    ```powershell
    choco install terraform -y
    ```
4.  Restart your terminal for changes to take effect.

## Option B: Manual Installation (Official HashiCorp Method)

If you cannot use Chocolatey, you can install the binary manually.

1.  Go to the official download page: [Terraform Downloads](https://developer.hashicorp.com/terraform/install).
2.  Under **Windows**, download the `amd64` (64-bit) ZIP archive.
3.  Extract the ZIP file. It contains a single executable: `terraform.exe`.
4.  Create a folder on your drive, e.g., `C:\terraform`.
5.  Move `terraform.exe` into `C:\terraform`.
6.  **Add to System PATH:**
    *   Press the Windows Key and search for **Environment Variables**.
    *   Click **Edit the system environment variables**.
    *   Click the **Environment Variables...** button.
    *   Under *System variables*, select the **Path** variable and click **Edit**.
    *   Click **New** and add `C:\terraform`.
    *   Click **OK** on all windows to save.
7.  Restart your terminal.

## Step 3: Verify Installation

Open a fresh terminal and run:
```powershell
terraform -version
```
*Expected Output:* `Terraform v1.x.x (on windows_amd64)`

---

# ✅ 3. Install AWS CLI v2 for Windows

To allow Terraform to interact with your AWS account, you need the AWS CLI installed and configured locally.

## Step 1: Download & Install

1.  Download the official AWS CLI MSI installer for Windows:
    [Download AWS CLI v2 for Windows](https://awscli.amazonaws.com/AWSCLIV2.msi)
2.  Run the downloaded `.msi` file and follow the standard installation wizard prompts.

## Step 2: Verify Installation

Open a terminal and run:
```powershell
aws --version
```
*Expected Output:* `aws-cli/2.x.x Python/3.x.x Windows/10...`

---

# 🔑 4. Configure AWS Credentials

You need to provide your AWS local environment with an IAM User's access keys that have appropriate permissions (e.g., AdministratorAccess for learning purposes).

Run the following command in your terminal:
```powershell
aws configure
```

Provide the requested information:
*   **AWS Access Key ID:** `AKIAIOSFODNN7EXAMPLE`
*   **AWS Secret Access Key:** `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`
*   **Default region name:** `ap-south-1` *(or your preferred region)*
*   **Default output format:** `json`

## Target Credential Storage File

On Windows, the `aws configure` command stores your credentials securely in:
`C:\Users\<Your-Username>\.aws\credentials`

---

# 🔍 5. Verify AWS Access

To confirm that your terminal can successfully talk to AWS, run:
```powershell
aws sts get-caller-identity
```
This should return a JSON output showing your Account ID, User ID, and IAM ARN.

---

# 📚 Official Documentation Links

*   **Install Terraform:** [https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
*   **Install AWS CLI (Windows):** [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions-windows](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions-windows)
*   **Terraform AWS Provider Docs:** [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---
**End of Documentation**
