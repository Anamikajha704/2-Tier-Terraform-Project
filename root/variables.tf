variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "region" {
  type        = string
  description = "The AWS region where resources will be deployed"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

# --- Subnets ---
variable "public_sub_1a_cidr" {
  type        = string
  description = "CIDR block for public subnet 1a"
}

variable "public_sub_2b_cidr" {
  type        = string
  description = "CIDR block for public subnet 2b"
}

variable "private_sub_3a_cidr" {
  type        = string
  description = "CIDR block for application private subnet 3a"
}

variable "private_sub_4b_cidr" {
  type        = string
  description = "CIDR block for application private subnet 4b"
}

variable "private_sub_5a_cidr" {
  type        = string
  description = "CIDR block for database private subnet 5a"
}

variable "private_sub_6b_cidr" {
  type        = string
  description = "CIDR block for database private subnet 6b"
}

# --- Database Credentials ---
variable "db_username" {
  type        = string
  description = "Database administrative username"
}

variable "db_password" {
  type        = string
  description = "Database administrative password"
  sensitive   = true
}


variable "certificate_domain_name" {
  type        = string
  description = "Primary domain name for the ACM SSL certificate"
}

variable "additional_domain_name" {
  type        = string
  description = "Alternative domain name (SAN) for the ACM SSL certificate"
}
