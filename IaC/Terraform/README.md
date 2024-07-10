# Infrastructure using Terraform YAML templates!

**Note: Infrastructure written using Terraform!**

This Terraform project creates the following resources in an AWS multi-AZ environment:

- **VPC**: Creates one Virtual Private Cloud.
- **Public Subnets**: Creates two public subnets in two different Availability Zones (AZs).
- **Internet Gateway**: Creates an internet gateway for the VPC.
- **Route Table**: Configures a route table to provide internet access to the subnets.
- **EKS Cluster**: Deploys an EKS cluster using the Terraform module `terraform-aws-modules/eks/aws`. The EKS cluster includes two t2.micro EC2 nodes.
- **State Management**: Utilizes Terraform workspaces and a remote backend to store the state file in an S3 bucket and manage state locks using a DynamoDB table.
- **Vault Integration**: Supports integration with Vault to supply secrets in an encrypted form.

## Commands

1. `terraform init`: Initializes the Terraform working directory.
2. `terraform plan`: Creates an execution plan to preview the changes.
3. `terraform apply`: Applies the changes required to reach the desired state.
4. `terraform destroy`: Deletes the created resources in the cloud.
