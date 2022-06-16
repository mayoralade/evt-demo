output "application_url" {
  value       = "http://${module.frontend.load_balancer_hostname}"
  description = "Frontend URL"
}
