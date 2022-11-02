resource "helm_release" "prometheus" {
    name       = "prometheus"
    repository = "https://prometheus-community.github.io/helm-charts"
    chart      = "kube-prometheus-stack"
    namespace  = var.namespace
    version    = var.chart_version
    values     = [file("${path.module}/values.yaml")]
    depends_on = [kubernetes_namespace.monitoring]

    set {
        name  = "podSecurityPolicy.enabled"
        value = "true"
    }

    set {
        name = "server.persistentVolume.enabled"
        value = "false"
    }
}