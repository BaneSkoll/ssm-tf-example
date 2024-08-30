variable "region" {
  description = "Region where the AWS resources will be created"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR of VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_range" {
  description = "CIDR range for public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_range" {
  description = "CIDR range for private subnet"
  default = "10.0.2.0/24" 
}

variable "instance_type" {
  description = "Example instance type"
  default = "t2.micro"
}

variable "ami" {
  description = "Image of EC2 instance"
  default = "ami-02d3770deb1c746ec"
  # Amazon Linux 2 AMI. Will change based on region or AMI chosen for instance
}
