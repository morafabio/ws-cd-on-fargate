variable "region" {
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "state_bucket" {
  type        = string
}

variable "state_lock_table" {
  type        = string
}

variable "github_token" {
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  sensitive   = true
}
