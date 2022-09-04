terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud
  folder_id = var.folder
  zone      = "ru-central1-a"
}
resource "yandex_compute_instance" "vm-1" {
  name = "node"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8hguc7o9hhr5bcvhql"
      size     = 40
    }
  }

  network_interface {
    subnet_id  = "e9bpen7ln9abjbcsud2l"
    nat        = true
    ip_address = "10.128.0.10"
  }

  metadata = {
    user-data = "${file("~/terraform/meta.txt")}"
  }

  provisioner "local-exec" {
    command = "sed -i 's/host1/'${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}'/' ./hosts"
  }
}