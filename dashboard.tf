resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.8.2"
  namespace  = "kube-system"

  depends_on = [
    module.eks.eks_managed_node_groups
  ]
}

resource "helm_release" "kubernetes_dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  version          = "5.7.0"
  namespace        = "kubernetes-dashboard"
  create_namespace = true

  depends_on = [
    module.eks.eks_managed_node_groups
  ]
}
