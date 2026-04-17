output "vm_id" {
  description = "Monitoring VM ID"
  value       = nirvana_compute_vm.monitoring.id
}

output "vm_public_ip" {
  description = "Monitoring VM public IP"
  value       = nirvana_compute_vm.monitoring.public_ip
}

output "vm_private_ip" {
  description = "Monitoring VM private IP"
  value       = nirvana_compute_vm.monitoring.private_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = nirvana_networking_vpc.monitoring.id
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${nirvana_compute_vm.monitoring.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${nirvana_compute_vm.monitoring.public_ip}:9090"
}
