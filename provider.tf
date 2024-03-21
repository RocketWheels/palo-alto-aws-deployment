# Specify the Terraform version and required providers
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "vault" {
  # Provider configuration
  address = var.vault_hostname # The address of the Vault server
  token   = var.vault_token # Your Vault token
  # You can also specify other parameters like namespace, if you're using Vault Enterprise, etc.
}

# Read AWS secrets from Vault
data "vault_generic_secret" "aws_secrets" {
  path = "aws/creds/admin" # Replace with the actual path to your AWS secrets in Vault
}

data "vault_generic_secret" "my_secrets" {
  path = "kv/pub-key"
}


# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_generic_secret.aws_secrets.data["access_key"]
  secret_key = data.vault_generic_secret.aws_secrets.data["secret_key"]
  token      = data.vault_generic_secret.aws_secrets.data["security_token"]
}