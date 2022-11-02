resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}