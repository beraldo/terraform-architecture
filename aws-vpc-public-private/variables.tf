
variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "ec2_ami_id" {
  default     = "ami-008d819eefb4b5ee4" # Ubuntu
  description = "AMI Image ID"
}
