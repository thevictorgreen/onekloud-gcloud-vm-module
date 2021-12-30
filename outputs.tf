output "public_instance_internal_ip" {
  value = google_compute_instance.public_instance.network_interface.0.network_ip
}

output "public_instance_external_ip" {
  value = "${var.vm_settings.ip_cfg.has_public_ip ? google_compute_instance.public_instance.network_interface.0.access_config.0.nat_ip : ""}"
}