resource "helm_release" "kube_prometheus_stack" {
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://prometheus-community.github.io/helm-charts"

}
