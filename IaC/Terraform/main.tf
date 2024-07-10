resource "aws_vpc" "eksVpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "PublicSubnetAZ1" {
  vpc_id            = aws_vpc.eksVpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.az1
}

resource "aws_subnet" "PublicSubnetAZ2" {
  vpc_id            = aws_vpc.eksVpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.az2
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eksVpc.id
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.eksVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PublicSubnetAZ1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.PublicSubnetAZ2.id
  route_table_id = aws_route_table.rt.id
}

provider "vault" {
  address          = "http://50.19.180.193:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "5e84c80a-87bd-83bc-a2c1-4020089eb91f"
      secret_id = "f2391d0e-0be8-aa82-d8f9-02966f94b19b"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
} // Can be accessed value using data.vault_kv_secret_v2.example.data["username"]

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = aws_vpc.eksVpc.id
  subnet_ids               = [aws_subnet.PublicSubnetAZ1.id, aws_subnet.PublicSubnetAZ2.id]
  control_plane_subnet_ids = [aws_subnet.PublicSubnetAZ1.id, aws_subnet.PublicSubnetAZ2.id]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large", "t2.micro"]
  }

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.micro"]

      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::123456789012:role/hukmaram"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}





