output "name" {
  value = "${kubernetes_pod.demoapp_pod.metadata.0.name}"
}