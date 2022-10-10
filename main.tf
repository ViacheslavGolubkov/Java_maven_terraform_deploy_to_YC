terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  }
  variable "TOKEN" {
    description = "Yandex cloud iam token"
    type = string
  }
  variable "cloud_id" {
    description = "Yandex cloud_id"
    type = string
  }
  variable "folder_id" {
    description = "Yandex folder_id"
    type = string
  }

  provider "yandex" {
  token     = var.TOKEN
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
  }

  resource "yandex_vpc_network" "network-1" {
  name = "network-1"
  }

  resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  }


  resource "yandex_compute_instance" "vm-1" {
  name = "vm-1"
  platform_id = "standard-v1"
  zone = "ru-central1-a"

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = "${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}"
    agent = false
  }

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87tirk5i8vitv9uuo1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

  resource "yandex_compute_instance" "vm-2" {
  name = "vm-2"
  platform_id = "standard-v1"
  zone = "ru-central1-a"

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = "${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}"
    agent = false
  }

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87tirk5i8vitv9uuo1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}
 
  output "external_ip_address_java_app" {
  description = "Java app external IP"
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
  }


  output "internal_ip_address_java_app" {
  description = "Java app internal IP"
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
  }

  output "external_ip_address_monitor" {
  description = "My external IP"
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
  }

  output "internal_ip_address_monitor" {
  description = "My internal IP"
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }
