output "load_balancer_hostname" {
  value = var.add_ingress ? kubernetes_ingress_v1.this[0].status.0.load_balancer.0.ingress.0.hostname : null
}
