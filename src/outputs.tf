output "vm_web_output" {
  value = yandex_compute_instance.platform_web.name && yandex_compute_instance.platform_web.network_interface[0].nat_ip_address && yandex_compute_instance.platform_web.fqdn
}

output "vm_db_output" {
  value = yandex_compute_instance.platform_db.name && yandex_compute_instance.platform_db.network_interface[0].nat_ip_address && yandex_compute_instance.platform_db.fqdn
}
