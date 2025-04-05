# variable "state_bucket" {
#   type        = string
# }
#
# variable "state_lock_table" {
#   type        = string
# }

variable "dockerhub_username" {
  type        = string
  sensitive   = true
}

variable "dockerhub_token" {
  type        = string
  sensitive   = true
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

variable "aws_region" {
  default     = "us-east-1"
}