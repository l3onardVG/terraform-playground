variable "aws_region" {
  type        = string
  description = "AWS Region to be deployed"
  default     = "us-east-2"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance (t2.micro is free tier eligible)"
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

variable "op_service_account_token" {
  type        = string
  description = "1Password Service Account Token for accessing secrets (set via TF_VAR_op_service_account_token)"
  sensitive   = true
}

variable "vpc_id" {
  type = string
  default     = "vpc-62cb4009"
}

variable "subnet_id" {
   type = string
  default     = "subnet-98d566f3"
}