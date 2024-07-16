provider "kubernetes" {
  # config_path = "~/.kube/config"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token

}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = var.namespace
  }
}
