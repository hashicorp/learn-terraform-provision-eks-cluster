output chart {
    value = helm_release.helm_chart.chart
}

output status {
    value = helm_release.helm_chart.status
}