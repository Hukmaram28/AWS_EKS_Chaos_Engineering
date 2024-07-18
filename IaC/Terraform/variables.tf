variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "cluster_name" {
  type        = string
  default     = "my-cluster"
  description = "cluster name"
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

variable "tfstate_bucket_name" {
  type        = string
  default     = "tf-state-storage-hukma"
  description = "terraform state bucket name"
}

variable "dynamodb_table_name" {
  type        = string
  default     = "terraform-lock"
  description = "terraform state bucket name"
}

variable "vault_details" {
  type = object({
    address          = string
    skip_child_token = bool
    auth_login_path  = string
    role_id          = string
    secret_id        = string
    mount            = string
    secret_name      = string
  })
  default = {
    address          = "http://ab7a7ce583fe14aaeac03cb54a452d9a-766910427.us-east-1.elb.amazonaws.com:8200/"
    skip_child_token = true
    auth_login_path  = "auth/approle/login"
    role_id          = "1f4aca33-f130-7662-5aab-1f7c30e33ba4"
    secret_id        = "e7e6a594-51cc-9a21-53f2-7d784a9ecd52"
    mount            = "crypteye"
    secret_name      = "database/config"
  }
}

variable "namespace" {
  type        = string
  default     = "dev"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "mysql root user name"
}

variable "db_password" {
  type        = string
  default     = "Kinal@231"
  description = "mysql user password"
}

variable "db_root_password" {
  type        = string
  default     = "Ijkas@123"
  description = "mysql root user password"
}
