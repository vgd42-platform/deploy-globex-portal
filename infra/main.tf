# Azure resources of portal (vendor globex).
# The vendor changes only the two values marked below, by PR. The platform module
# decides everything else (SKUs, security, naming).

# --- State lives in the platform's storage account (set by the infra workflow) ---
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none" # registered once at bootstrap
}

# --- The platform module ---
module "vendor_kit" {
  source = "github.com/vgd42-platform/platform-config//modules/vendor-kit?ref=main"

  # Set at onboarding - don't change
  vendor                    = "globex"
  app                       = "portal"
  resource_group_name       = "rg-vgd42-globex-portal"
  storage_account_name      = "stvgd42globexportal"
  app_identity_principal_id = "a1b059fb-5616-4622-9225-277cc28fdc39"

  # Vendor may change (PR, a code owner approves)
  containers = ["orders"]
  enable_sql = false
}

output "blob_endpoint" {
  value = module.vendor_kit.blob_endpoint
}
