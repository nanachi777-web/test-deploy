terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.70.0"
    }
  }
}

provider "azurerm" {
    features {}
  subscription_id = "f363c849-35b3-477a-a710-5163108f2d45"
}