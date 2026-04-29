resource "azurerm_resource_group" "test" {
  name     = "testResourceGroup"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "mycontainerregistry"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  sku                 = "Basic"
  admin_enabled       = false
  
}

resource "azurerm_container_app_environment" "example" {
  name                       = "my-environment"
  location                   = azurerm_resource_group.test.location
  resource_group_name        = azurerm_resource_group.test.name
 
}

resource "azurerm_container_app" "example" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.example.id
  resource_group_name          = azurerm_resource_group.test.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
  ingress {
    external_enabled = true
    target_port     = 80
    traffic_weight {
      percentage = 100
    }
  }

  registry {
    server = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password_secret_name = "mysecret"
  }

  secret {
    name = ""
    value = azurerm_container_registry.acr.admin_password
  }
}