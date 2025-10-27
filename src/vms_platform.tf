### Ex.3 vars
variable "vm_db_zone" {
  type = string
  default = "ru-central1-b"
  description = "Рабочая зона"
}

/*
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Имя виртуальной машины"
}
*/

variable "vm_db_platform_id" {
  type = string
  default = "standard-v3"
  description = "ID виртуальной платформы"
}

/*
variable "vm_db_hw_cores" {
  type = number
  default = 2
  description = "Количество виртуальных ядер"
}

variable "vm_db_hw_memory" {
  type = number
  default = 2
  description = "Объем оперативной памяти"
}

variable "vm_db_core_frac" {
  type = number
  default = 20
  description = "Ограничение пиковой производительности CPU"
}

 */
variable "vm_db_hw_preemptible" {
  type = bool
  default = true
  description = "Прерываемость работы ВМ"
}
variable "vm_db_hw_nat" {
  type = bool
  default = true
  description = "Активировать NAT"
}

/*
variable "vm_db_hw_serial_port_enable" {
  type = number
  default = 1
  description = "Активировать серийный порт для удаленного доступа"
}
 */
