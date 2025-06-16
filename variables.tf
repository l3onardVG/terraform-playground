variable "aws_region" {
  type        = string
  description = "AWS Region to be deployed"
  default     = "us-east-1"
}

variable "aws_sub_region" {
  type        = string
  description = "AWS SubRegion to be deployed"
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "leo_vpc"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "10.0.1.0/24"
}

variable "instance_ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-084568db4383264d4"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
  default     = "leonard-tf-key"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public SSH key"
  default     = "leonard-tf-key.pub"
}