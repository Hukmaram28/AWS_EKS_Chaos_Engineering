variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr block for vpc"
}

variable "subnet1_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "cidr block for subnet 1"
}

variable "subnet2_cidr" {
  type        = string
  default     = "10.0.16.0/24"
  description = "cidr block for subnet 2"
}

variable "az1" {
  type        = string
  default     = "us-east-1a"
  description = "availability zone 1"
}

variable "az2" {
  type        = string
  default     = "us-east-1b"
  description = "availability zone 1"
}
