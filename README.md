Домашнее задание к занятию «Основы Terraform. Yandex Cloud» - `Иншаков Владимир`

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант. [+]
2. Установлен инструмент Yandex CLI. [+]
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src). [+]

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.12.0
![Screen_01_01](https://github.com/MrVanG0gh/ter_homework_02/blob/main/Screenshots/Screenshot_01_01.png)


1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

---

### Решение 1

1.  Изучил проект. В файл `variables.tf` добавил недостающие идентификаторы облака и директории. 
2.  Был создан сервисный аккаунт с парой ключей доступа.
3.  Осуществил генерацию ssh-ключей. Открытую часть записал в переменную `vms_ssh_root_key`
4.  Проект проинициализировался. При запуске возникают ошибки. Я отметил, что в файле `main.tf` присутствуют некоторые ошибки:
    - `platform_id = "standart-v4"` -> `platform_id = "standard-v3"` # опечатка в слове `standard` и неверная версия (допустимы v1, v2, v3)
    - `cores         = 1` -> `cores         = 2` # минимальное количество виртуальных ядер должно быть равно 2
    
![Screen_01_02](https://github.com/MrVanG0gh/ter_homework_02/blob/main/Screenshots/Screenshot_01_02.png)

5.  Произвел подключение по ssh и выполнил команду `curl ifconfig.me`
![Screen_01_03](https://github.com/MrVanG0gh/ter_homework_02/blob/main/Screenshots/Screenshot_01_03.png)

6.  Параметр `preemptible = true` (прерываемость) позволяет сэкономить деньги при аренде виртуальных мощностей за счет того, что виртуальная машина после 24 часов работы будет остановлена. (может быть также остановлена, если провайдеру экстренно потребуются мощности).
    Параметр `core_fraction=5` позволяет задать максимальную загрузку виртуальных ядер. Понижая этот параметр можно также сэкономить деньги при аренде виртуальных мощностей.

### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

### Решение 2

variables.tf
```
###cloud vars


variable "cloud_id" {
  type        = string
  default     = "b1gd0ene28ce38jum5ol"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gh84ji5m46hok29kbf"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnceZd2rCKdINN9bbS0QQ5X4mubdFaheN6XcNHbb+u4"
  description = "ssh-keygen -t ed25519"
}

### Ex.2 vars

variable "family_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство устанавливаемой ОС"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя виртуальной машины"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v3"
  description = "ID виртуальной платформы"
}

variable "vm_web_hw_cores" {
  type = number
  default = 2
  description = "Количество виртуальных ядер"
}
variable "vm_web_hw_memory" {
  type = number
  default = 1
  description = "Объем оперативной памяти"
}

variable "vm_web_core_frac" {
  type = number
  default = 20
  description = "Ограничение пиковой производительности CPU"
}

variable "vm_web_hw_preemptible" {
  type = bool
  default = true
  description = "Прерываемость работы ВМ"
}
variable "vm_web_hw_nat" {
  type = bool
  default = true
  description = "Активировать NAT"
}
variable "vm_web_hw_serial_port_enable" {
  type = number
  default = 1
  description = "Активировать серийный порт для удаленного доступа"
}
```

main.tf
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.family_name
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_hw_cores
    memory        = var.vm_web_hw_memory
    core_fraction = var.vm_web_core_frac
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_hw_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_hw_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_hw_serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```

После команды `terraform plan` конфигурация не изменилась:
![Screen_02_01](https://github.com/MrVanG0gh/ter_homework_02/blob/main/Screenshots/Screenshot_02_01.png)

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

### Решение 3
`vms_platform.tf`
```
### Ex.3 vars
variable "vm_db_zone" {
  type = string
  default = "ru-central1-b"
  description = "Рабочая зона"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя виртуальной машины"
}

variable "vm_db_platform_id" {
  type = string
  default = "standard-v3"
  description = "ID виртуальной платформы"
}

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
variable "vm_db_hw_serial_port_enable" {
  type = number
  default = 1
  description = "Активировать серийный порт для удаленного доступа"
}
```
![Screen_03_01](https://github.com/MrVanG0gh/ter_homework_02/blob/main/Screenshots/Screenshot_03_01.png)


### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

------