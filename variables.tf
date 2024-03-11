variable "infisical_hostname" {
  description = "hostname to retreve secrets"
  type = string
  sensitive = true
}

variable "infisical_service_token" {
  description = "token to authenticate"
  type = string
  sensitive = true
}

variable "firewall_count" {
  description = "amount of firewalls desired"
  default = 2
}