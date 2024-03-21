variable "vault_hostname" {
  description = "hostname to retreve secrets"
  type = string
  sensitive = true
}

variable "vault_token" {
  description = "token to authenticate"
  type = string
  sensitive = true
}

variable "firewall_count" {
  description = "amount of firewalls desired"
  default = 1
}