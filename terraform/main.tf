terraform {
  required_providers {
    nirvana = {
      source = "nirvana-labs/nirvana"
    }
  }
}

provider "nirvana" {}

# VPC for Monitoring Stack
resource "nirvana_networking_vpc" "monitoring" {
  name        = var.vpc_name
  region      = var.region
  project_id  = var.project_id
  subnet_name = "${var.vpc_name}-subnet"
  tags        = var.tags
}

# Firewall rule - SSH access
resource "nirvana_networking_firewall_rule" "monitoring_ssh" {
  vpc_id              = nirvana_networking_vpc.monitoring.id
  name                = "monitoring-ssh"
  protocol            = "tcp"
  source_address      = "0.0.0.0/0"
  destination_address = nirvana_networking_vpc.monitoring.subnet.cidr
  destination_ports   = ["22"]
  tags                = var.tags
}

# Firewall rule - Grafana (HTTP)
resource "nirvana_networking_firewall_rule" "monitoring_grafana" {
  vpc_id              = nirvana_networking_vpc.monitoring.id
  name                = "monitoring-grafana"
  protocol            = "tcp"
  source_address      = "0.0.0.0/0"
  destination_address = nirvana_networking_vpc.monitoring.subnet.cidr
  destination_ports   = ["3000"]
  tags                = var.tags
}

# Firewall rule - Prometheus
resource "nirvana_networking_firewall_rule" "monitoring_prometheus" {
  vpc_id              = nirvana_networking_vpc.monitoring.id
  name                = "monitoring-prometheus"
  protocol            = "tcp"
  source_address      = "0.0.0.0/0"
  destination_address = nirvana_networking_vpc.monitoring.subnet.cidr
  destination_ports   = ["9090"]
  tags                = var.tags
}

# Firewall rule - Node Exporter (for scraping other hosts)
resource "nirvana_networking_firewall_rule" "monitoring_node_exporter" {
  vpc_id              = nirvana_networking_vpc.monitoring.id
  name                = "monitoring-node-exporter"
  protocol            = "tcp"
  source_address      = nirvana_networking_vpc.monitoring.subnet.cidr
  destination_address = nirvana_networking_vpc.monitoring.subnet.cidr
  destination_ports   = ["9100"]
  tags                = var.tags
}

# Monitoring VM
resource "nirvana_compute_vm" "monitoring" {
  name              = var.vm_name
  project_id        = var.project_id
  region            = var.region
  subnet_id         = nirvana_networking_vpc.monitoring.subnet.id
  public_ip_enabled = true
  os_image_name     = var.os_image
  instance_type     = var.instance_type

  boot_volume = {
    size = var.boot_volume_size
    type = "abs"
    tags = var.tags
  }

  ssh_key = {
    public_key = var.ssh_public_key
  }

  tags = var.tags
}
