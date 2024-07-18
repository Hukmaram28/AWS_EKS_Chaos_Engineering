terraform {
  backend "s3" {
    bucket         = "tf-state-storage-hukma"
    key            = "crypteye/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
