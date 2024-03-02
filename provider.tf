# Specify the Terraform version and required providers
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    infisical = {
      # version = <latest version>
      source = "infisical/infisical"
    }
  }
}

provider "infisical" {
    host          = var.infisical_hostname
    service_token = var.infisical_service_token
}

data "infisical_secrets" "my-secrets" {
  env_slug    = "dev"
  folder_path = "/"
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = data.infisical_secrets.my-secrets.secrets["AWS_ACCESS_KEY"].value
  secret_key = data.infisical_secrets.my-secrets.secrets["AWS_SECRET_KEY"].value
}