# ☁️ AWS Juice Shop Deployment with Terraform

This guide automates the infrastructure setup for deploying [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) in AWS using **Terraform**.

---

## ✅ What This Automation Includes
- Custom **VPC** (`10.0.0.0/16`)
- **Public** and **Private** subnets
- **Internet Gateway** and **NAT Gateway**
- **Route Tables** for public and private access
- **Security Groups** for both EC2 instances
- **Bastion EC2 Instance** (public)
- **Juice Shop EC2 Instance** (private)
- **Docker installation and Juice Shop deployment** via `user_data.sh`

---

## 📁 Project Structure

terraform-juice-shop/ 
├── main.tf # Core infrastructure 

├── security_groups.tf # Security group definitions 

├── variables.tf # (Optional) Input variables 

├── outputs.tf # Output IPs and values 

├── provider.tf # AWS provider setup 

├── user_data.sh # Docker + Juice Shop script


---

## 🚀 Getting Started

### 1. Install Terraform
Download Terraform: https://developer.hashicorp.com/terraform/downloads

### 2. Clone the Repo or Create the Files

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Apply the Infrastructure
```bash
terraform apply
```

### 🔐 SSH Access to Bastion Host
```bash
ssh -i ~/.ssh/<your-private-ssh-key>.pem ubuntu@<public_ip>

```

### 🧪 Test Juice Shop (Public EC2 Only or via SSH Tunnel)
```bash
http://<bastion_public_ip>:3000
```

Or create an SSH tunnel:
```bash
ssh -i ~/.ssh/<your-private-ssh-key>.pem -L 3000:<private_ec2_ip>:3000 ubuntu@<bastion_public_ip>
```

Then open:
```bash
http://localhost:3000
```

To destroy all created infrastructure:
```bash
terraform destroy
```


