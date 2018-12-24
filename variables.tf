# AWS Config

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {}

variable "instance_access_key" {}

variable "aws_instance_user" {
  description = "Instance user"
  default     = "admin"
}

variable "aws_key_path" {}
