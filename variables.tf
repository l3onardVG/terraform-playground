variable "aws_region" {
  type = string
  description = "AWS Region to be deployed"
  default = "us-east-1"
}

variable "aws_sub_region" {
  type = string
  description = "AWS SubRegion to be deployed"
  default = "us-east-1a"
}

variable "instance_ami" {
  type = string
  description = "AWS SubRegion to be deployed"
  default = "ami-0953476d60561c955"
}

variable "instance_type" {
  type = string
  description = "AWS SubRegion to be deployed"
  default = "t2.micro"
}