variable "resource_group_name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "sku_name" {
  type    = string
  default = "B1"
}
