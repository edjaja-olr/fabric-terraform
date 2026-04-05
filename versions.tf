terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    fabric = {
      source  = "microsoft/fabric"
      version = "~> 1.9"
    }
  }

  # Remote backend – replace with your Azure Storage Account details
  # or comment out to use local state during first init
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfabricstate"   # must be globally unique
    container_name       = "tfstate"
    key                  = "fabric/medallion.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.spn_client_id
  client_secret   = var.spn_client_secret
}

provider "azuread" {
  tenant_id     = var.azure_tenant_id
  client_id     = var.spn_client_id
  client_secret = var.spn_client_secret
}

provider "fabric" {
  tenant_id     = var.azure_tenant_id
  client_id     = var.spn_client_id
  client_secret = var.spn_client_secret
}
