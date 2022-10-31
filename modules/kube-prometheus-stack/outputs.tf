output chart {
    value = helm_release.kube_prometheus_stack.chart
}

output status {
    value = helm_release.kube_prometheus_stack.status
}