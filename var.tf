variable "db_password" {
    type    = string
    description = "RDS DB instance password should be More than 8 letters."
    default="{{db_password}}"
}
variable "db_username" {
    type    = string
    description = "RDS DB instance password should be More than 8 letters."
    default="{{db_username}}"
}
variable "aws_access_key" {
    type    = string
    description = "Your access key"
    default="{{aws_access_key}}"
}
variable "aws_secret_key" {
    type    = string
    description = "Your secret key"
    default="{{aws_secret_key}}"
}
# =================================================================================
variable "key_name" {
    type    = string
    default = "team2Key"
}
variable "my_region" {
    type    = string
    default = "ap-northeast-2"
}

variable "my_az1" {
    type    = string
    default = "ap-northeast-2a"
}
variable "my_az2" {
    type    = string
    default = "ap-northeast-2c"
}
variable "api_ami_id-a" {
    type    = string
    # default = "{{api_ami_id}}"
    default = "ami-0214414f047aea460"
}
variable "api_ami_id-c" {
    type    = string
    # default = "{{api_ami_id}}"
    default = "ami-0cbdbc595049d3731"
}
variable "ui_ami_id-a" {
    type    = string
    # default = "{{ui_ami_id}}"
    default = "ami-0c8ee51f1770990ed"
}
variable "ui_ami_id-c" {
    type    = string
    # default = "{{ui_ami_id}}"
    default = "ami-0c1005b46db897acf"
}
variable "bastion-ami" {
    type    = string
    # default = "{{bastion-ami}}"
    default = "ami-08aec266a69e616af"
}
variable "target_group_path" {
    type    = string
    default = "/health"
}
variable "db_port" {
    type    = string
    default = "3306"
}
