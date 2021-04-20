terraform {
  required_providers {
    az = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "az" {
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name  = "charanrg"
    storage_account_name = "charanstore609162"
    container_name       = "tfstate"
    key                  = "lab9.1.terraform.tfstate"
  }
}