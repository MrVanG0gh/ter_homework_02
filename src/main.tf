resource "yandex_vpc_network" "develop" {
  name            = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name            = var.vpc_name
  zone            = var.default_zone
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = var.default_cidr
}
## новая подсеть для работы в другой зоне
resource "yandex_vpc_subnet" "develop2" {
  name            = var.vpc_name2
  zone            = var.default_zone2
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = var.default_cidr2
}

data "yandex_compute_image" "ubuntu" {
  family          = var.family_name
}
resource "yandex_compute_instance" "platform_web" {
  # name          = var.vm_web_name
  name            = local.vm_web_lname
  platform_id     = var.vm_web_platform_id
  zone            = var.vm_web_zone
  resources {
    # cores       = var.vm_web_hw_cores
    cores         = var.vms_resources.vm_web_resources.cores
    # memory      = var.vm_web_hw_memory
    memory        = var.vms_resources.vm_web_resources.memory
    # core_fraction = var.vm_web_core_frac
    core_fraction = var.vms_resources.vm_web_resources.core_fraction
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
metadata = var.common_metadata
  /*
  metadata = {
    serial-port-enable = var.vm_web_hw_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
*/
}


### new resource Ex.3

resource "yandex_compute_instance" "platform_db" {
  # name          = var.vm_db_name
  name        = local.vm_db_lname
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vms_resources.vm_db_resources.cores
    memory        = var.vms_resources.vm_db_resources.memory
    core_fraction = var.vms_resources.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_hw_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop2.id
    nat       = var.vm_db_hw_nat
  }

  metadata = var.common_metadata
}
  /*
   metadata = {
    serial-port-enable = var.vm_db_hw_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
*/
