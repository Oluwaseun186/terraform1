variable "instance_type" {
  type        = string
  default     = "t2.small"
  description = "This is the EC2 instance type"
}

variable "virtual_machine" {
  type        = string
  default     = "ami-084568db4383264d4"
  description = "AMI ID for the EC2 instance"
}

variable "service_name" {
  type    = string
  default = "forum"
}

variable "environment" {
  type    = string
  default = "dev"
}


locals {
  service_tag = "${var.service_name}-${var.environment}"
}

locals {
  aws_tag = "${var.virtual_machine}:${var.instance_type}"
  owner   = "ubuntu"
}
