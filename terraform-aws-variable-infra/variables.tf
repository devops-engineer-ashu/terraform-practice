variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  # description = "The AWS region to deploy resources in"
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "project_name" {
  description = "The name of the project. This is a required input."
  type        = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "route_table" {
  type    = string
  default = "0.0.0.0/0"
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}