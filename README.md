# AWS-VPC-Peering-Using-Terraform

## Project Overview

This project demonstrates how to create **two VPCs in AWS** and establish a **VPC peering connection** between them using **Terraform**.
It includes:

* Creation of **VPC-A** and **VPC-B**
* Creation of **subnets** and **route tables** in each VPC
* Setting up **VPC peering**
* Configuring **routes** to allow cross-VPC communication
* Optional verification using EC2 instances

This hands-on lab is implemented entirely using Terraform to automate the infrastructure.

---

![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Gemini_Generated_Image_x6hvbgx6hvbgx6hv.png)

## Prerequisites

Before starting, ensure you have the following:

* **AWS Account** with appropriate permissions to create VPCs, subnets, and EC2 instances
* **Terraform installed** (v1.5+ recommended)
* AWS CLI configured with your credentials
* Basic understanding of AWS networking concepts

---

## Step 1: Create Project Directory

```bash
mkdir D:\AWS_TF\vpcpeering
cd D:\AWS_TF\vpcpeering
```

Create the following files:

* `provider.tf`
* `variables.tf`
* `vpc_a.tf`
* `vpc_b.tf`
* `peering.tf`
* `outputs.tf`

---

## Step 2: Define AWS Provider

In `provider.tf`:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

This sets the AWS region for all resources.

---

## Step 3: Define Variables

In `variables.tf`:

```hcl
variable "vpc_a_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_b_cidr" {
  default = "10.1.0.0/16"
}
```

This allows easy modification of VPC CIDR blocks.

---

## Step 4: Create VPC-A and Subnet-A

In `vpc_a.tf`:

```hcl
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-A"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-A"
  }
}

resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "RT-A"
  }
}

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}
```

This creates **VPC-A**, a **subnet**, and a **route table**.

---

## Step 5: Create VPC-B and Subnet-B

In `vpc_b.tf`:

```hcl
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-B"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-B"
  }
}

resource "aws_route_table" "rt_b" {
  vpc_id = aws_vpc.vpc_b.id

  tags = {
    Name = "RT-B"
  }
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_b.id
}
```

This creates **VPC-B**, a **subnet**, and a **route table**.

---

## Step 6: Configure VPC Peering

In `peering.tf`:

```hcl
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc_a.id
  peer_vpc_id = aws_vpc.vpc_b.id
  auto_accept = true

  tags = {
    Name = "VPC-A-to-VPC-B"
  }
}

resource "aws_route" "route_a_to_b" {
  route_table_id            = aws_route_table.rt_a.id
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "route_b_to_a" {
  route_table_id            = aws_route_table.rt_b.id
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
```

This creates the **VPC peering connection** and updates **route tables** to allow traffic between VPC-A and VPC-B.

---

## Step 7: Define Outputs

In `outputs.tf`:

```hcl
output "vpc_a_id" {
  value = aws_vpc.vpc_a.id
}

output "vpc_b_id" {
  value = aws_vpc.vpc_b.id
}

output "peering_connection_id" {
  value = aws_vpc_peering_connection.peer.id
}
```

This allows easy retrieval of **VPC IDs** and **peering connection ID** after deployment.

---

## Step 8: Initialize Terraform

```powershell
terraform init
```

* Installs the AWS provider
* Prepares Terraform to manage resources

---

## Step 9: Plan the Deployment

```powershell
terraform plan
```

* Terraform checks what resources will be created
* Ensures there are no errors before applying

---

## Step 10: Apply the Configuration

```powershell
terraform apply
```

* Terraform will prompt for confirmation
* Type `yes` to proceed
* Terraform creates VPCs, subnets, route tables, and the peering connection

After successful apply, a **terraform.tfstate** file is created.

---

## Step 11: Verify Resources

### Using Terraform

```powershell
terraform show
```

You should see:

* `aws_vpc.vpc_a`
* `aws_vpc.vpc_b`
* `aws_vpc_peering_connection.peer`
* Subnets and route tables

### Using AWS Console

1. Go to **VPC → Your VPCs** → Verify VPC-A and VPC-B exist
2. Go to **VPC → Peering Connections** → Verify status is **Active**
3. Go to **Route Tables** → Verify routes exist for cross-VPC traffic

---

## Optional Step 12: Test Connectivity Between VPCs

1. Launch **EC2 instance in Subnet-A** of VPC-A
2. Launch **EC2 instance in Subnet-B** of VPC-B
3. Ensure security groups allow **ICMP traffic (ping)**
4. SSH into EC2-A and run:

```bash
ping 10.1.1.X   # Replace with EC2-B private IP
```

* Successful ping confirms **VPC peering works**

---
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(262).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(263).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(264).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(265).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(266).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(267).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(268).png)
![Alt Text](https://github.com/Naveen15github/AWS-VPC-Peering-Using-Terraform/blob/c38ee237a65e55d8414f9494229660356e72243e/Screenshot%20(269).png)


## Summary

* Created **two VPCs** and **subnets**
* Configured **route tables** for each VPC
* Established **VPC peering connection**
* Verified connectivity between VPCs

This hands-on project demonstrates **full Terraform automation** of AWS networking resources.

---

