variable "db_name" {
    default = "testdb"
}
variable "db_sg_id" {}
variable "private_sub_5a_id" {}
variable "private_sub_6b_id" {}
variable "db_username" {}

variable "db_password" {
  type        = string
  description = "The password for the database"
  sensitive   = true  #Prevents the password from printing in plain text to CI/CD and terminal logs
}


variable "db_sub_name" {
    default = "mydb-subnet-a-b"
}
