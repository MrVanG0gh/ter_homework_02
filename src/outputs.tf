output "vm_web_name" {
  value = yandex_compute_instance.platform_web.name
}

output "vm_web_ext_ip" {
  value = yandex_compute_instance.platform_web.network_interface[0].nat_ip_address
}

output "vm_web_fqdn" {
  value = yandex_compute_instance.platform_web.fqdn
}

output "vm_db_name" {
  value = yandex_compute_instance.platform_db.name
}

output "vm_db_ext_ip" {
  value = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
}

output "vm_db_fqdn" {
  value = yandex_compute_instance.platform_db.fqdn
}