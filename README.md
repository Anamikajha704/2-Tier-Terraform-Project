Automated AWS Infrastructure Deployment with Terraform
This project automates the deployment of a secure, highly available, and scalable multi-tier AWS infrastructure using Terraform. 
It leverages a remote S3 backend with DynamoDB state locking to ensure secure collaboration.

Prerequisites:
Before you begin, ensure you have the following resources configured in your AWS Console:
• Route 53 Hosted Zone: A public hosted zone for your domain name.
• ACM Certificate: A valid SSL/TLS certificate issued via AWS Certificate Manager (ACM) matching your domain name.


Step by Step Setup Guide:

1. Configure the Remote Backend
To securely store your Terraform state file, you need to set up a remote backend.
1. Create an S3 Bucket:
	• Name your bucket and select your preferred region.
	• Important: Enable Bucket Versioning to protect against accidental state deletions or human error.
2. Create a DynamoDB Table:
	• Create a new table dedicated to state locking.
	• Set the Partition Key name to LockID and its type to String.
2. Generate SSH Key Pairs
Generate a public-private key pair to allow secure SSH access to your EC2 instances.
bash
cd modules/key/
ssh-keygen
Use code with caution.
When prompted, enter a name for your key (e.g., client_key). If you use a different name, make sure to update your Terraform configuration references.
3. Initialize your Environment Files
Now, configure your backend variables and infrastructure properties.
Define the Backend (root/backend.tf)
Create or open the root/backend.tf file and paste the following block, replacing the placeholders with your actual AWS resource names:
hcl
terraform {
  backend "s3" {
    bucket         = "YOUR_S3_BUCKET_NAME"
    key            = "backend/infrastructure.tfstate"
    region         = "us-east-1"
    dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME"
  }
}
Use code with caution.
Define the Infrastructure Variables (root/terraform.tfvars)
Create a file named root/terraform.tfvars and fill in your network, database, and domain configurations:
hcl
region                  = "us-east-1"
project_name            = "my-cloud-app"
vpc_cidr                = "10.0.0.0/16"

# Subnet Allocations
public_sub_1a_cidr         = ""
public_sub_2b_cidr         = ""
private_sub_3a_cidr         = ""
private_sub_4b_cidr         = ""
private_sub_5a_cidr         = ""
private_sub_6b_cidr         = ""

# Database Credentials
db_username             = "db_admin"
db_password             = "SecurePassword123!" # Use a secrets manager in production

# Domain Configuration
certificate_domain_name = "example.com"
additional_domain_name  = "*.example.com"

Deployment
Once your configurations are set up, run the following commands to deploy your infrastructure into the cloud:

1. Navigate to the root directory:
cd root

2. Initialize the working directory and install required providers:
terraform init

3. Review the execution plan to verify exactly what resources will be built:
terraform plan

4. Deploy the infrastructure:
terraform apply

When prompted, type yes and hit Enter to confirm the deployment.

Thanks alot for reading :) 
