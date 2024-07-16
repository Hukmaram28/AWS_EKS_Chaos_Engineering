resource "aws_vpc" "eksVpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "PublicSubnetAZ1" {
  vpc_id                  = aws_vpc.eksVpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "PublicSubnetAZ2" {
  vpc_id                  = aws_vpc.eksVpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
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

/* provider "vault" {
  address          = var.vault_details.address
  skip_child_token = var.vault_details.skip_child_token

  auth_login {
    path = var.vault_details.auth_login_path

    parameters = {
      role_id   = var.vault_details.role_id
      secret_id = var.vault_details.secret_id
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = var.vault_details.mount
  name  = var.vault_details.secret_name
} // Can be accessed value using data.vault_kv_secret_v2.example.data["username"] */

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
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
      principal_arn     = "arn:aws:iam::211125556960:user/eksuser"

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

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  depends_on = [ module.eks ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
  depends_on = [ module.eks ]
}

