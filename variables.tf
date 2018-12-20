# AWS Config

variable "aws_access_key" {
  default = "YOUR_ADMIN_ACCESS_KEY"
}

variable "aws_secret_key" {
  default = "YOUR_ADMIN_SECRET_KEY"
}

variable "aws_region" {
  #  default = "us-west-1"  
  default = "us-east-2"
}

variable "instance_access_key" {}

variable "aws_instance_user" {
  description = "Instance user"
  default     = "admin"
}

variable "aws_key_path" {
  description = "Instance access key path"
  default     = "/Users/arif.reza/Downloads/test.pem"
}
