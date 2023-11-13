terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.4.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.11.0"
    }
     kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
  }
}
