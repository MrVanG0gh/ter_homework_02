resource "yandex_vpc_network" "develop" {
  name            = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name            = var.vpc_name
  zone            = var.default_zone
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family          = var.family_name
}
resource "yandex_compute_instance" "platform" {
  name            = var.vm_web_name
  platform_id     = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_hw_cores
    memory        = var.vm_web_hw_memory
    core_fraction = var.vm_web_core_frac
  }
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible   = var.vm_web_hw_preemptible
  }
  network_interface {
    subnet_id     = yandex_vpc_subnet.develop.id
    nat           = var.vm_web_hw_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_hw_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}


### new resource Ex.3

resource "yandex_compute_instance" "platform" {
  name            = var.vm_db_name
  platform_id     = var.vm_db_platform_id
  zone            = var.vm_db_zone
  resources {
    cores         = var.vm_db_hw_cores
    memory        = var.vm_db_hw_memory
    core_fraction = var.vm_db_core_frac
  }
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible   = var.vm_db_hw_preemptible
  }
  network_interface {
    subnet_id     = yandex_vpc_subnet.develop.id
    nat           = var.vm_db_hw_nat
  }

  metadata = {
    serial-port-enable = var.vm_db_hw_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
