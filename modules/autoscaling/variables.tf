variable project_name {}
variable "ami" {
    default = "ami-053b0d53c279acc90"
}
variable "cpu" {
    default = "t2.micro"
}
variable "key_name" {}
variable "web_sg_id" {}
variable "max_size" {
    default = 6
}
variable "min_size" {
    default = 2
}
variable "desired_cap" {
    default = 3
}
variable "asg_health_check_type" {
    default = "ELB"
}
variable "private_sub_3a_id" {}
variable "private_sub_4b_id" {}
variable "targetgroup_arn" {}
variable "target_group_arn" {}
variable "private_subnet_3a_id" {}
variable "private_subnet_4b_id" {}
